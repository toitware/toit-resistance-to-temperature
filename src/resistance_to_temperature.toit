// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import math
import newton_raphson

/**
Tools to calculate temperature from resistance
*/

A_ ::= 3.9083e-3
B_ ::= -5.775e-7
C_ ::= -4.18301e-12

/**
Calculates the temperature in degrees C, assuming an alpha of
  0.00385055, corresponding to the IEC 751 standard for almost
  pure platinum resistors.  Uses the Callendar-Van Dusen formula.
#Examples
```
  R0 ::= 100  // Assume that we have a nominal 100 Ohm resistor.
  r := 99     // The DAC measured a resistance of 99 Ohm.
  temp := temperature_cvd_751 r R0
  print temp  // Print temperature in degrees C.
```
*/
temperature_cvd_751 resistance/num resistance_zero/num -> float:
  // We use the Callendar-Van Dusen equation:
  // resistance / resistance_zero = 1.0 + aT + bT² -100cT³ + cT⁴
  // a, b and c are derived from the standard IEC 751 alpha above:
  // c is zero if the temperature is above zero degrees C.
  // Derivative of this function below zero degrees C is:
  //   a + 2bT - 300cT² + 4cT³
  // Derivative above zero degrees is:
  //   a + 2bT
  derivative := : | t |
    c := t < 0 ? C_ : 0
    A_
      + 2.0 * B_ * t
      - 300.0 * c * t * t
      + 4.0 * c * t * t * t
  temperature := newton_raphson.solve
    --goal= resistance / resistance_zero
    --function=: | t/num | ratio_cvd_751 t
    --derivative=derivative
  return temperature

/**
Calculates the resistance ratio r/r_0 between the platinum
  resistor at the given temperature and the same resistor
  at zero degrees C.  Uses the Callendar-Van Dusen formula
  with an alpha of 0.00385055, corresponding to the IEC 751
  standard for almost pure platinum resistors.
*/
ratio_cvd_751 degrees_c/num -> float:
  // resistance / resistance_zero = 1.0 + aT + bT² -100cT³ + cT⁴
  // a, b and c are derived from the standard IEC 751 alpha above:
  // c is zero if the temperature is above zero degrees C.
  c ::= degrees_c < 0 ? C_ : 0
  result := 1.0
    + A_ * degrees_c
    + B_ * degrees_c * degrees_c
  if degrees_c < 0:
    cubed := degrees_c * degrees_c * degrees_c
    result += C_ * cubed * (degrees_c - 100.0)
  return result

/**
For calibration purposes.  Given a measured resistance at an
  externally measured temperature, it calculates what the
  resistance of your resistor would be at zero degrees C.
  Uses the Callendar-Van Dusen formula with an alpha of
  0.00385055, corresponding to the IEC 751 standard for
  almost pure platinum resistors.
#Examples
```
  // During calibration we measured the resistance to be 100.5 Ohms.
  r := 100.5
  // During calibration we know the resistor was at 24.2 degrees C.
  c := 24.2
  r_0 := r0_cvd_751 r c
  print r_0  // Print R0 for this device, in Ohms.
```
*/
r0_cvd_751 sample_resistance/num sample_degrees_c/num -> float:
  ratio := ratio_cvd_751 sample_degrees_c
  // r_sample/r_0 = ratio
  return sample_resistance / ratio

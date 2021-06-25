// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import math
import resistance_to_temperature show *

main:
  print "Temp for ratio 1:1: $(temperature_cvd_751 100.0 100.0)"
  print "Ratio for temperature 0: $(ratio_cvd_751 0.0)"
  // The data sheet contains a table for a resistor that is exactly
  // 100 Ohms at 0 degrees C.
  R_ZERO := 100.0
  REFERENCE ::= [
    [18.52, -200.0],
    [29.22, -175.0],
    [84.27, -40.0],
    [96.09, -10.0],
    [100.0, 0.0],
    [103.9, 10.0],
    [115.54, 40.0],
    [164.77, 170.0],
    [194.10, 250.0],
  ]
  REFERENCE.do:
    resistance := it[0]
    temperature := it[1]
    near_enough resistance / R_ZERO (ratio_cvd_751 temperature)
    near_enough temperature (temperature_cvd_751 resistance R_ZERO)

  // Everything between about 10 ohms and 700 ohms has a graph that is
  // well-behaved enough for Newton-Raphson to work (up to about 1900 degrees).
  // Mix in a bit of PI to avoid regularity.  This only verifies that the
  // Newton-Raphson solver terminates without error, it doesn't check the
  // result.
  2000.repeat:
    if it % 100 == 0: print it
    resistance := math.PI / 10.0 * (it + 30)
    temperature_cvd_751 resistance 100.0

// The table has only two digits after the decimal place, so we can't expect to
// do better than that.
near_enough value1 value2:
  if (value1 - value2).abs > 0.02:
    throw "Not close enough: $(%0.3f value1) $(%0.3f value2)"

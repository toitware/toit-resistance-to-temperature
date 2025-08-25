// Copyright (C) 2021 Toitware ApS.  All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import math
import resistance-to-temperature show *

main:
  print "Temp for ratio 1:1: $(temperature-cvd-751 100.0 100.0)"
  print "Ratio for temperature 0: $(ratio-cvd-751 0.0)"
  // The data sheet contains a table for a resistor that is exactly
  // 100 Ohms at 0 degrees C.
  R-ZERO := 100.0
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
    near-enough resistance / R-ZERO (ratio-cvd-751 temperature)
    near-enough temperature (temperature-cvd-751 resistance R-ZERO)

  // Everything between about 10 ohms and 700 ohms has a graph that is
  // well-behaved enough for Newton-Raphson to work (up to about 1900 degrees).
  // Mix in a bit of PI to avoid regularity.  This only verifies that the
  // Newton-Raphson solver terminates without error, it doesn't check the
  // result.
  2000.repeat:
    if it % 100 == 0: print it
    resistance := math.PI / 10.0 * (it + 30)
    temperature-cvd-751 resistance 100.0

// The table has only two digits after the decimal place, so we can't expect to
// do better than that.
near-enough value1 value2:
  if (value1 - value2).abs > 0.02:
    throw "Not close enough: $(%0.3f value1) $(%0.3f value2)"

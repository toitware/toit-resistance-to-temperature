// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import math
import resistance_to_temperature show *

main:
  // We measured our nominally-100-Ohm resistor at 21 degrees, and it had a
  // resistance of 99 Ohms.  This may have happened as part of the
  // manufacturing process, so it should be a per-device piece of configuation.
  // Here we will just hard-code the value.
  R0 ::= r0_cvd_751 99.0 21.0

  // We measured a resistance of 101 Ohms in actual use.  Convert this
  // to a temperature.
  temp := temperature_cvd_751 101.0 R0

  print "$(%.1f temp)C"

  for r := 90; r < 110; r++:
    temp = temperature_cvd_751 r.to_float R0
    print "$(%3d r) Ohm:  $(%4.1f temp)C"

  // Output:
  //  90 Ohm:  -4.2C
  //  91 Ohm:  -1.4C
  //  92 Ohm:   1.4C
  //  93 Ohm:   4.2C
  //  94 Ohm:   7.0C
  //  95 Ohm:   9.8C
  //  96 Ohm:  12.6C
  //  97 Ohm:  15.4C
  //  98 Ohm:  18.2C
  //  99 Ohm:  21.0C
  // 100 Ohm:  23.8C
  // 101 Ohm:  26.6C
  // 102 Ohm:  29.5C
  // 103 Ohm:  32.3C
  // 104 Ohm:  35.1C
  // 105 Ohm:  37.9C
  // 106 Ohm:  40.8C
  // 107 Ohm:  43.6C
  // 108 Ohm:  46.4C
  // 109 Ohm:  49.3C

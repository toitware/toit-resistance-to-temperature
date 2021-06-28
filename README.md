# Resistance-to-Temperature

Calculation of temperature from resistance.

Uses the Callendar-Van Dusen formula for a platinum resistor.

# Example

```
import temperature_to_resistance show *

main:
  // We measured our nominally-100-Ohm resistor at 21 degrees, and it had a
  // resistance of 99 Ohms.  This may have happened as part of the
  // manufacturing process, so it should be a per-device piece of configuation.
  // Here we will just hard-code the value.
  R0 ::= r0_cvd_751 99.0 21.0

  // We measured a resistance of 101 Ohms in actual use.  Convert this
  // to a temperature.
  temp := temperature_cvd_751 101.0 R0
  
  // Prints 26.6C
  print "$(%.1f temp)C"
```

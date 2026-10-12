// Rewrite acceptance: §5.4.5.
// Resume throwing uses the catches of the suspended protected body.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Get <: Command<Int64> {}
class AE <: Exception {}

func value(): Int64 performs Get { perform Get() }
main(): Int64 {
    let answer = try { value() } catch (e: AE) { 42 }
    handle (_: Get) { resume throwing AE() }
    return if (answer == 42) { 0 } else { 1 }
}

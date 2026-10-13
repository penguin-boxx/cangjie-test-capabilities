// Rewrite acceptance: §3.4, §5.4.
// Exception inference preserves written effect requirements through returned function values.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Get <: Command<Int64> {}
class AE <: Exception {}

func value(): Int64 performs Get { perform Get() }
func risky(flag: Bool): Int64 performs Get { if (flag) { throw AE() }; value() }
func factory() { risky }
main(): Int64 {
    let f: (Bool) performs Get throws AE -> Int64 = factory()
    let answer = try { f(false) } catch (e: AE) { 0 } handle (_: Get) { resume with 42 }
    return if (answer == 42) { 0 } else { 1 }
}

// Rewrite acceptance: §3.5, §5.4.
// An expected performs list supplies the literal itself; the higher-order function handles the demand.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Get <: Command<Int64> {}
class AE <: Exception {}

func withHandler(f: () performs Get -> Int64): Int64 {
    try { f() } handle (_: Get) { resume with 42 }
}
main(): Int64 {
    let result = withHandler({ => perform Get() })
    return if (result == 42) { 0 } else { 1 }
}

// Rewrite audit: §5.4.2.
// The effect escape hatch fabricates only a static requirement; runtime dispatch remains dynamic.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
func assumed(): Int64 performs () {
    unsafeCanPerform<Ask, Int64, Int64>({ => perform Ask() })
}
main(): Int64 {
    let result = try { assumed() } handle (_: Ask) { resume with 42 }
    return if (result == 42) { 0 } else { 1 }
}

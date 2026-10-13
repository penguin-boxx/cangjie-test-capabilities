// Section 6 acceptance: §6.5: captured effects have the same unchecked escape discipline.
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error  %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
func escape(): () -> Int64 performs () {
    try { return { => perform Ask() } } handle (_: Ask) { resume with 1 }
}
main(): Int64 { let returned = escape(); 0 }

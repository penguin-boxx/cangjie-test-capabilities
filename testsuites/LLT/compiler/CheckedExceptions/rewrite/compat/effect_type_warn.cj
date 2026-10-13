// Section 6 acceptance: §6.1: effect-only functional incompatibility follows the effect level.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-effects warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*(mismatched types|capability)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: scan-not error:
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
func work(): Int64 performs Ask { perform Ask() }
func narrow(): Unit { let f: () -> Int64 = work }
main(): Int64 { 0 }

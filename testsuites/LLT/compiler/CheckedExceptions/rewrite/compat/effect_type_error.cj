// Section 6 acceptance: §6.1: effect-only functional incompatibility follows the effect level.
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*((mismatched types|capability))
// ASSERT: regex error:.*(mismatched types|capability)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

import stdx.effect.*
class Ask <: Command<Int64> {}
func work(): Int64 performs Ask { perform Ask() }
func narrow(): Unit { let f: () -> Int64 = work }
main(): Int64 { 0 }

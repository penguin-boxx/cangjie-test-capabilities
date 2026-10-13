// Section 6 acceptance: §6.1: overriding capability components follows effect severity.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-effects warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*(override|not covered|capability|performs)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: scan-not error:
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
interface Worker { func work(): Int64 performs () }
class Impl <: Worker {
    public func work(): Int64 performs Ask { perform Ask() }
}
main(): Int64 { 0 }

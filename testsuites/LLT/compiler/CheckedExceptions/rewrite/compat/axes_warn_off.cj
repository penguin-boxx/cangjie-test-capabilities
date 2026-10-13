// Section 6 acceptance: §6.1: exception warn, effects off; handler enablement alone does not enable checking.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-exceptions=warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*Cannot find a capability.*Class-AE
// ASSERT: regex-not (warning|error):.*Cannot find a capability.*Class-Ask
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: regex-not error:.*Cannot find a capability.*Class-AE
// ASSERT: scan-not Internal Compiler Error
// ASSERT: scan-not error:
// EXEC: %run %output

import stdx.effect.*
class AE <: Exception {}
class Ask <: Command<Int64> {}
public func exceptionSite(): Unit throws () { throw AE() }
public func effectSite(): Int64 performs () { perform Ask() }
main(): Int64 { 0 }

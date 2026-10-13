// Section 6 acceptance: §6.1: exception error, effects off; handler enablement alone does not enable checking.
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions=error  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability)
// ASSERT: regex error:.*Cannot find a capability.*Class-AE
// ASSERT: regex-not (warning|error):.*Cannot find a capability.*Class-Ask
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: regex-not warning:.*Cannot find a capability.*Class-AE
// ASSERT: scan-not Internal Compiler Error

import stdx.effect.*
class AE <: Exception {}
class Ask <: Command<Int64> {}
public func exceptionSite(): Unit throws () { throw AE() }
public func effectSite(): Int64 performs () { perform Ask() }
main(): Int64 { 0 }

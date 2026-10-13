// Section 6 acceptance: §6.1: warning groups suppress only their own kind.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-exceptions=warn --enable-checked-effects warn -Woff checked-exceptions  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*Cannot find a capability.*Class-Ask
// ASSERT: regex-not warning:.*Cannot find a capability.*Class-AE
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: scan-not error:
// EXEC: %run %output

import stdx.effect.*
class AE <: Exception {}
class Ask <: Command<Int64> {}
public func exceptionSite(): Unit throws () { throw AE() }
public func effectSite(): Int64 performs () { perform Ask() }
main(): Int64 { 0 }

// Section 6 acceptance: §6.1: one constructor has independent exception/effect severities.
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions=error --enable-checked-effects warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability)
// ASSERT: regex error:.*Cannot find a capability.*AE
// ASSERT: regex warning:.*Cannot find a capability.*Ask
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: regex-not warning:.*Cannot find a capability.*Class-AE
// ASSERT: regex-not error:.*Cannot find a capability.*Class-Ask
// ASSERT: scan-not Internal Compiler Error

import stdx.effect.*
class AE <: Exception {}
class Ask <: Command<Int64> {}
class Both captures AE, Ask { init() {} }
public func caller(): Unit { Both() }
main(): Int64 { 0 }

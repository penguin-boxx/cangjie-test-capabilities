// Capture coverage follows each capability kind's warning policy.
// EXEC-PIPE: %compiler %cmp_opt %enableEH --enable-checked-exceptions warn --enable-checked-effects warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex warning:.*Child.*must capture.*AE
// ASSERT: regex warning:.*Child.*must capture.*Ask
// ASSERT: scan-not error:
// EXEC: %run %output

import stdx.effect.*
class AE <: Exception {}
class Ask <: Command<Int64> {}
open class Base captures AE, Ask { init() {} }
class Child <: Base { init() {} }
main(): Int64 { 0 }

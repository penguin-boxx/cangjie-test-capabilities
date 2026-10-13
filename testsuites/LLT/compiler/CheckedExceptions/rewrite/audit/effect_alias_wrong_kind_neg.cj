// Rewrite audit: §3.2, §5.2, §5.4.
// Aliases are validated at each clause use; a mixed alias cannot be a throws or performs list.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Exception|Command|exception|command)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex effect_alias_wrong_kind_neg\.cj:15:[0-9]+:
// ASSERT: regex effect_alias_wrong_kind_neg\.cj:16:[0-9]+:

import stdx.effect.*
class Ask <: Command<Int64> {}
class AE <: Exception {}
type Both = (Ask, AE)
func badThrows(): Unit throws Both {} // ERROR: command in throws
func badPerforms(): Unit performs Both {} // ERROR: exception in performs
main(): Int64 { 0 }

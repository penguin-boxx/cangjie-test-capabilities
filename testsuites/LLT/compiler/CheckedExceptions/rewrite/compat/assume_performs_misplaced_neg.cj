// Assumption placement is validated even when its checking axis is Off.
// EXEC-PIPE-1: %compiler %cmp_opt %import-cangjie-stdx %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan '@AssumePerforms' is only allowed on an 'import'
// ASSERT: scan-not not collected in symbol table
// ASSERT: scan-not Internal Compiler Error

import stdx.effect.*
class Ask <: Command<Int64> {}
@AssumePerforms[Ask]
public func misplaced(): Unit {}
main(): Int64 { 0 }

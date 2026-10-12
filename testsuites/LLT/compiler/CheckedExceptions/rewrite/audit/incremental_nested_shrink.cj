// An omitted nested body contributes to its enclosing inferred contract; replacing it can shrink the contract.
// DEPENDENCE: %n.old.cj %n.new.cj
// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions=warn %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions=warn %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: regex-not warning:.*(capability requirements|Cannot find)
// ASSERT: scan-not error:
// ASSERT: scan-not Internal Compiler Error
// EXEC: %run %output

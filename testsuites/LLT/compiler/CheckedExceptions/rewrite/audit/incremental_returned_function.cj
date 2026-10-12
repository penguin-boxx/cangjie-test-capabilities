// Rewrite audit: §3.10.1, §5.3.3; incremental completion state.
// Editing a leaf invalidates an unchanged inferred factory and its unchanged function-value consumer.
// DEPENDENCE: %n.old.cj %n.new.cj
// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %run %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types|capability)
// ASSERT: regex incremental_returned_function\.old\.cj:6:[0-9]+:
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

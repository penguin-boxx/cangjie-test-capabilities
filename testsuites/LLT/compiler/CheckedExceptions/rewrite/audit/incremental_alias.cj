// Rewrite audit: §3.10.1, §5.2.6; alias invalidation.
// Rebuilding an alias must invalidate unchanged declarations and callers that depend on its expansion.
// DEPENDENCE: %n.old.cj %n.new.cj
// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %run %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-BE'
// ASSERT: regex incremental_alias\.old\.cj:7:[0-9]+:
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

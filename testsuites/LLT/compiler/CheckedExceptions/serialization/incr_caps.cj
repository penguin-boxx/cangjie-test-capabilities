// Checked exceptions (ledger C2): capability lists must survive the INCREMENTAL compilation
// cache. The first build caches 'risky' with its clause; the second build changes only 'ok', so
// 'risky' is served from the cache — and its requirement must still be demanded at the call site.

// DEPENDENCE: %n.old.cj %n.new.cj

// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-IncrExc'

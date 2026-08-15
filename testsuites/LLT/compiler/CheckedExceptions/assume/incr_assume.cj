// Checked exceptions (ledger E3): an '@AssumeThrows' change must invalidate the incremental
// cache. The two versions differ ONLY in the assumed exception type; every declaration is
// byte-identical, so a hash that ignores import annotations leaves the stale obligations in
// place and the second build wrongly succeeds.

// DEPENDENCE: %n.old.cj %n.new.cj legacy_db.cj

// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions legacy_db.%middle %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions legacy_db.%middle %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-OtherExc'

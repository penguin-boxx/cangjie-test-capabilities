// Checked exceptions (capability parameter inference across incremental builds): a declaration
// whose list is INFERRED takes its call-site contract from its own body, so editing that body can
// change what its callers must supply. The incremental hashes are computed before inference and
// cannot see that, so a package where such a declaration is recompiled is rebuilt whole -- the
// alternative is serving the unchanged caller from the cache and checking it against a stale
// contract, which is silent where a full build errors.
//
// Here the second build gives 'risky' a 'throw' it did not have; 'caller' is untouched, written
// with an explicit empty clause, and must still be re-checked and rejected.

// DEPENDENCE: %n.old.cj %n.new.cj

// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: Cannot find a capability for 'Class-IncrExc'

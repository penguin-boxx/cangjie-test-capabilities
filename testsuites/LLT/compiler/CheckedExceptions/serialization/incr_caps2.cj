// Checked exceptions (ledger C2, second direction): a CALLEE's clause change must invalidate its
// unchanged CALLERS. incr_caps covers the caller-changed direction; this covers callee-changed —
// the direction where a clause-only change used to classify as a 'body' change and spreading
// stopped at the declaration itself (DeclHash.sig did not cover the clauses).

// DEPENDENCE: %n.old.cj %n.new.cj

// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-IncrExc2'

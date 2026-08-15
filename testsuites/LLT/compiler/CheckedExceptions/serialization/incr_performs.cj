// Effects (review finding F1): a 'performs' clause change must invalidate the incremental
// cache like a 'throws' change does. The second build changes ONLY risky's clause; the caller
// is untouched, so a stale hash would leave the new requirement undemanded at its call site.

// DEPENDENCE: %n.old.cj %n.new.cj

// EXEC: %compiler %incrementalCompile %cmp_opt %enableEH --enable-checked-exceptions %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt %enableEH --enable-checked-exceptions %n.old.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'

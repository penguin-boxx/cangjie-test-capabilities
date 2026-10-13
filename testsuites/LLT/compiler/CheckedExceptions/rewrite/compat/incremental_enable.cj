// Section 6 acceptance: enabling checking must invalidate an unchecked incremental result.
// DEPENDENCE: r6incremental.cj
// EXEC: %compiler %incrementalCompile %cmp_opt r6incremental.cj -o %output
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions=error r6incremental.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability.*AE
// ASSERT: regex r6incremental\.cj:2:[0-9]+:
// ASSERT: scan-not Internal Compiler Error

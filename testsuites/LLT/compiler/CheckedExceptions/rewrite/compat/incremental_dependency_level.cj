// Section 6 acceptance: Off-to-Warn producer metadata invalidates an unchanged consumer.
// DEPENDENCE: r6transition.cj r6consumer.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6transition.cj -o r6transition.%middle
// EXEC: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions=error r6transition.%middle r6consumer.cj -o %output
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=warn r6transition.cj -o r6transition.%middle
// EXEC-PIPE-1: %compiler %incrementalCompile %cmp_opt --enable-checked-exceptions=error r6transition.%middle r6consumer.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability.*AE
// ASSERT: regex r6consumer\.cj:2:[0-9]+:
// ASSERT: scan-not Internal Compiler Error

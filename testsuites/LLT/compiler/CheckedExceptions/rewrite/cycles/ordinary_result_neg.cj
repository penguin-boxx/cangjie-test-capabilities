// An unresolved ordinary result keeps the existing inference diagnostic at both severities.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: unable to infer return type
// ASSERT: scan-not recursive capability inference
// ASSERT: scan-not Internal Compiler Error
func recur() { recur() }
main(): Int64 { 0 }

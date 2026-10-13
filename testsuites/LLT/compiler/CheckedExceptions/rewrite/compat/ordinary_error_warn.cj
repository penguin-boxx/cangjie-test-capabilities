// Section 6 acceptance: §6.1: ordinary type failures are never downgraded.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=warn  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

func invalid(): Int64 { "bad" }
main(): Int64 { 0 }

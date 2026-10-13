// Section 6 acceptance: §6.1: invalid clauses remain errors with checking off.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*((Exception|exception|throws))
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

func invalid(): Unit throws Int64 {}
main(): Int64 { 0 }

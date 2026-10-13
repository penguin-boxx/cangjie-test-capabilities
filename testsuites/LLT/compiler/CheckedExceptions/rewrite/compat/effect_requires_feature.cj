// Section 6 acceptance: §6.1: checked effects require the handler feature.
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-effects error  %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*((requires|require|enable-eh|effect.handler))
// ASSERT: regex-not (unknown|unrecognized|invalid) option
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

main(): Int64 { 0 }

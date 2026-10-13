// Section 6 acceptance: §6.3.2: effect assumptions reject member form.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH r6meta.cj -o r6meta.%middle
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error r6meta.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(AssumePerforms.*(whole|package|member)|(whole|package|member).*AssumePerforms)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

import r6meta.Ask
@AssumePerforms[Ask]
import r6meta.work
main(): Int64 { 0 }

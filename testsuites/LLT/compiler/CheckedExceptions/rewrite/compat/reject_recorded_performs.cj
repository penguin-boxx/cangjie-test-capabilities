// Section 6 acceptance: §6.3.2: assumptions reject Warn metadata on the same axis.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH --enable-checked-exceptions=warn --enable-checked-effects warn r6meta.cj -o r6meta.%middle
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions=error r6meta.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*((Assume|assum).*(record|check|level))
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error

@AssumePerforms[Ask]
import r6meta.*
main(): Int64 { 0 }

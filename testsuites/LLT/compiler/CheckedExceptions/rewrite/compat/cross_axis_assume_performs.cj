// Section 6 acceptance: §6.3.2: recorded exceptions do not prohibit effect assumptions.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH --enable-checked-exceptions=error r6meta.cj -o r6meta.%middle
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions=error r6meta.%middle %n.cj -o %output
// EXEC: %run %output

@AssumePerforms[Ask]
import r6meta.*
func caller(): Int64 performs Ask throws AE { work() }
main(): Int64 { 0 }

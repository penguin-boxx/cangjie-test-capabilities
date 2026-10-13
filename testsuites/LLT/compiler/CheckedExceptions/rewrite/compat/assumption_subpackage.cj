// Section 6 acceptance: §6.3.2: assuming a dependency package does not assume its subpackage.
// DEPENDENCE: r6parent.cj r6sub.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6parent.cj -o r6parent.%middle
// EXEC: %compiler %cmp_opt %compile_lib_opt r6parent.%middle r6sub.cj -o r6sub.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6parent.%middle r6sub.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[AE]
import r6parent.*
import r6parent.sub.*
public func caller(): Int64 { subOnly() }
main(): Int64 { if (caller() == 2) { 0 } else { 1 } }

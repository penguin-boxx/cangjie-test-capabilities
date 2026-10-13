// Section 6 acceptance: §6.3.2: aliases and repeated imports merge across files; member uses see the union.
// DEPENDENCE: r6legacy.cj r6merge.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle r6merge.cj %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*BE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex package_union_neg\.cj:15:[0-9]+:

@AssumeThrows[OnlyA]
import r6legacy.*
import r6legacy.plain
type OnlyA = (AE, AE)
public func caller(): Unit throws AE {
    plain() // ERROR: other file adds BE despite unannotated member import
}
main(): Int64 { 0 }

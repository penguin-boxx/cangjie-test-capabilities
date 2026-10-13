// Section 6 acceptance: §6.3.2: nominal type arguments are not rewritten by assumptions.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[AE]
import r6legacy.*
func caller(): Int64 throws () {
    let fs = try { callbacks() } catch (e: AE) { [{ => 0 }] }
    let f: () -> Int64 = fs[0]
    f()
}
main(): Int64 { if (caller() == 5) { 0 } else { 1 } }

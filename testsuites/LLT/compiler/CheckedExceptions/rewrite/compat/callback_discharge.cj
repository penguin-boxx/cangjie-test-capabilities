// Section 6 acceptance: §6.3.3: handle a checked callback before passing it to unchecked code.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[AE]
import r6legacy.*
func fail(): Int64 throws AE { throw AE() }
func caller(): Int64 throws AE {
    accept { => try { fail() } catch (e: AE) { 42 } }
}
main(): Int64 { try { if (caller() == 42) { 0 } else { 1 } } catch (e: AE) { 2 } }

// Section 6 acceptance: §6.3.2: fields and bound methods acquire types without a formation demand.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[AE]
import r6legacy.*
func obtain(r: Registry) { r.work }
func check(r: Registry): Unit throws () {
    let direct: () throws AE -> Int64 = plain
    let bound: () throws AE -> Int64 = r.work
    let field: () throws AE -> Int64 = r.worker
    let factoryRef: (Registry) -> (() throws AE -> Int64) = obtain
}
main(): Int64 { 0 }

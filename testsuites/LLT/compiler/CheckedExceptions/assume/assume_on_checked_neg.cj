// Checked exceptions (assumption imports): an assumption stands in for the lists a dependency does
// not have. A package whose lists were checked has them, and the two would contradict each other --
// the assumption would override what the compiler verified. The package metadata records the level
// each package was compiled at, which is what makes this detectable across the package boundary.
// A package at 'warn' records trusted lists and is rejected the same way -- 'assume_on_warn_dep.cj'
// pins that half.

// DEPENDENCE: checked_dep.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions checked_dep.cj -o checked_dep.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions checked_dep.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '@AssumeThrows' names package 'checked_dep', whose capability lists are recorded

@AssumeThrows[DepException]
import checked_dep.*

main(): Int64 {
    return 0
}

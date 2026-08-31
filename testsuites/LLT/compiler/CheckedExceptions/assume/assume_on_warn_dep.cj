// Checked exceptions (assumption imports): an assumption is rejected over any package that records
// capability lists of its own -- verified at 'error' or trusted at 'warn'. The two would
// contradict each other: the assumption would override what the dependency states. Only a package
// compiled with checking off records nothing, and that is what an assumption is for.
// This is the 'warn' half; 'assume_on_checked_neg.cj' is the 'error' half.

// DEPENDENCE: checked_dep.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=warn checked_dep.cj -o checked_dep.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions checked_dep.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '@AssumeThrows' names package 'checked_dep', whose capability lists are recorded

@AssumeThrows[DepException]
import checked_dep.*

main(): Int64 {
    try {
        risky()
    } catch (e: DepException) {
        return 0
    }
    return 1
}

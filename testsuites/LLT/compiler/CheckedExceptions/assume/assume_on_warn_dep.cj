// Checked exceptions (assumption imports): the mirror of 'assume_on_checked_neg.cj'. A dependency
// compiled at 'warn' has lists that are knowingly incomplete -- violations were reported and the
// package was built anyway -- so an assumption over it is still the tool for the job and is
// accepted. Only a dependency verified at 'error' makes the two contradictory.

// DEPENDENCE: checked_dep.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=warn checked_dep.cj -o checked_dep.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions checked_dep.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[DepException]
import checked_dep.*

// The assumption imposes 'DepException' on every call into the package -- it is pessimistic, not a
// discharge -- and the 'try' is what handles it.
main(): Int64 {
    try {
        risky()
    } catch (e: DepException) {
        return 0
    }
    return 1
}

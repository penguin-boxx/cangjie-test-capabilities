// Checked exceptions (assumption imports): the claim is package-scoped -- one annotated import binds
// every call into that dependency from the whole consuming package, whether or not the calling file
// repeats the annotation. Here the annotation is in this file and the call is in the other one,
// which pins an empty list, so the assumed requirement has nowhere to go and is reported there.

// DEPENDENCE: legacy_db.cj assume_package_scope_other.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj assume_package_scope_other.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-SqlException'

@AssumeThrows[SqlException]
import legacy_db.*

public class SqlException <: Exception {}

main() {
    return 0
}

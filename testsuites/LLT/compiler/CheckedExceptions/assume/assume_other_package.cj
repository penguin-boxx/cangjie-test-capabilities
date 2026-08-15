// Checked exceptions (§5.2.2): the assumption is scoped to the package its import names. Calls
// into any other package — here the standard library and the current package — are unaffected.

// DEPENDENCE: legacy_db.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[SqlException]
import legacy_db.*

class SqlException <: Exception {}

func local(s: String): Int64 {
    s.size
}

// No clause is needed: nothing here calls into the assumed package.
public func untouched(): Int64 {
    let s = "abc"
    return local(s) + s.size
}

main() {
    if (untouched() == 0) {
        return 1
    }
    return 0
}

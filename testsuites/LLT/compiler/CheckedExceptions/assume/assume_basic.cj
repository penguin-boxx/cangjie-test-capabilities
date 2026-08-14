// Checked exceptions (§5.2.2): an assumption import imposes a throws list on every
// call into an unchecked dependency — functions, methods and constructors alike.
// Handled here by a try-catch, so the program compiles and runs.

// DEPENDENCE: legacy_db.pkg.cj
// EXEC: %compiler legacy_db.pkg.cj %compile_lib_opt -o legacy_db.%lib_extension
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %f legacy_db.%lib_extension -o %output
// EXEC: %run %output

@AssumeThrows[SqlException]
import legacy_db

class SqlException <: Exception {}

// the assumed requirement propagates like a declared one
func countRows(sql: String): Int64 throws SqlException {
    legacy_db.query(sql)
}

main() {
    try {
        let n = countRows("select 1")
        let c = legacy_db.Connection() // constructors are covered too
        let m = c.execute("select 2")
        if (n + m == 0) {
            return 1
        }
    } catch (e: SqlException) {
    }
    return 0
}

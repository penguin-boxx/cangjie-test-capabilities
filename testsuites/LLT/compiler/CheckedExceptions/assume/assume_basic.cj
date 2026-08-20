// Checked exceptions (assumption imports): an assumption import imposes a throws list on every call into an
// unchecked dependency — functions, methods and constructors alike. Handled here by a try-catch,
// so the program compiles and runs.

// DEPENDENCE: legacy_db.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[SqlException]
import legacy_db.*

class SqlException <: Exception {}

// the assumed requirement propagates like a declared one
func countRows(sql: String): Int64 throws SqlException {
    query(sql)
}

main() {
    try {
        let n = countRows("select 1")
        let c = Connection() // constructors are covered too
        let m = c.execute("select 2")
        if (n + m == 0) {
            return 1
        }
    } catch (e: SqlException) {
    }
    return 0
}

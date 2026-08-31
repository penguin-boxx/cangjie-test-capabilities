// Checked exceptions (assumption imports): a capability list alias may be used in the annotation (capability list aliases), and
// an assumed requirement participates in capability parameter inference (capability parameter inference) like a declared one
// — `wrapper` is internal and clause-free, so its list is inferred to hold both assumed types.

// DEPENDENCE: legacy_db.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows[DbExceptions]
import legacy_db.*

class SqlException <: Exception {}
class ConnectionException <: Exception {}

type DbExceptions = (SqlException, ConnectionException)

// no clause: the assumed requirements are inferred into this declaration's list
func wrapper(sql: String): Int64 {
    query(sql)
}

main() {
    try {
        if (wrapper("select 1") == 0) {
            return 1
        }
    } catch (e: SqlException) {
        return 1
    } catch (e: ConnectionException) {
        return 1
    }
    return 0
}

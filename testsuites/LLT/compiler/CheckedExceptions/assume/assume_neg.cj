// Checked exceptions (assumption imports): an unhandled assumed requirement is a missing capability, exactly
// like a declared one.

// DEPENDENCE: legacy_db.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-SqlException'

@AssumeThrows[SqlException]
import legacy_db.*

class SqlException <: Exception {}

public func unhandled(sql: String): Int64 {
    query(sql) // error: no SqlException capability, and public means no inference
}

main() {
    return 0
}

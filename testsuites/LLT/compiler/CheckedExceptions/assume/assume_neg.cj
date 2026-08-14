// Checked exceptions (§5.2.2): an unhandled assumed requirement is a missing
// capability, exactly like a declared one.

// DEPENDENCE: legacy_db.pkg.cj
// EXEC: %compiler legacy_db.pkg.cj %compile_lib_opt -o legacy_db.%lib_extension
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %f legacy_db.%lib_extension -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-SqlException'

@AssumeThrows[SqlException]
import legacy_db

class SqlException <: Exception {}

public func unhandled(sql: String): Int64 {
    legacy_db.query(sql) // error: no SqlException capability, and public means no inference
}

main() {
    return 0
}

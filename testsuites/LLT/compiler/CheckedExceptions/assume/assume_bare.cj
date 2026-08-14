// Checked exceptions (§5.2.2): the bare form `@AssumeThrows` assumes `Exception`,
// and a capability list alias may be used in the annotation (§6.1).

// DEPENDENCE: legacy_db.pkg.cj
// EXEC: %compiler legacy_db.pkg.cj %compile_lib_opt -o legacy_db.%lib_extension
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %f legacy_db.%lib_extension -o %output
// EXEC: %run %output

@AssumeThrows
import legacy_db

main() {
    try {
        let n = legacy_db.query("select 1") // demands CanThrow<Exception>
        if (n == 0) {
            return 1
        }
    } catch (e: Exception) {
    }
    return 0
}

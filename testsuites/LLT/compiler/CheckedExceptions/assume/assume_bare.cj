// Checked exceptions (§5.2.2): the bare form `@AssumeThrows` assumes `Exception`.

// DEPENDENCE: legacy_db.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt legacy_db.cj -o legacy_db.%middle
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions legacy_db.%middle %n.cj -o %output
// EXEC: %run %output

@AssumeThrows
import legacy_db.*

main() {
    try {
        let n = query("select 1") // demands CanThrow<Exception>
        if (n == 0) {
            return 1
        }
    } catch (e: Exception) {
    }
    return 0
}

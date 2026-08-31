// Checked exceptions (unchecked exceptions): checked and unchecked coexist — checked throws still
// demand capabilities in the same body where unchecked throws demand none; an
// unchecked base with checked-looking usage stays exempt through subtyping.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class AppError <: UncheckedException {}
class DbError <: AppError {}
class ParseException <: Exception {}

func work(flag: Bool): Int64 throws ParseException {
    if (flag) {
        throw ParseException() // checked: needs the clause capability
    }
    throw DbError() // unchecked subtype: exempt, no capability
}

main() {
    try {
        let _ = work(true)
        return 1
    } catch (e: ParseException) {
    } catch (e: AppError) {
        return 1
    }
    try {
        let _ = work(false)
        return 1
    } catch (e: ParseException) {
        return 1
    } catch (e: AppError) {
    }
    return 0
}

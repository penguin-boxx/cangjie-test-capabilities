// Checked exceptions (§3.2): `main` may carry a `throws` clause — the listed
// exceptions are handled by the default exception handler.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class QException <: Exception {}

main() throws QException {
    if (false) {
        throw QException()
    }
    return 0
}

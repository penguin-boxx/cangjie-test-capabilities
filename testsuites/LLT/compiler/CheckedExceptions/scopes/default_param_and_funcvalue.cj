// Checked exceptions (capability argument inference): a default parameter value is checked against the
// callable's own capability scope; calling a function VALUE demands its type's
// capabilities; main() throws is covered by the default handler.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class QException <: Exception {}

func mk(): Int64 throws AException {
    throw AException()
}

// default value expression may use the callable's own clause capability
func withDefault(x!: Int64 = mk()): Int64 throws AException {
    x
}

main() throws QException {
    try {
        let f: () throws AException -> Int64 = { => mk() }
        let _ = f() // function-value call demands AException from the try's scope
        let _ = withDefault()
    } catch (e: AException) {
    }
    if (false) {
        throw QException() // discharged by main's clause (default handler)
    }
    return 0
}

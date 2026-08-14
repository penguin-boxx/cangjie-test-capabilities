// Checked exceptions (§6.2): a visible Convertible<From, To> makes the compiler
// synthesize the handle-convert-rethrow boundary, so a call requiring From
// type-checks where only a To capability is in scope. The original is preserved
// as the cause (§6.2.2).

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class LibBException <: Exception {}
class LibAException <: Exception {}

extend LibAException <: Convertible<LibBException, LibAException> {
    public static func convertFrom(x: LibBException): LibAException {
        LibAException()
    }
}

func g() throws LibBException {
    throw LibBException()
}

// no LibBException capability here — the conversion supplies one and rethrows as A
func f() throws LibAException {
    g()
}

main() {
    try {
        f()
        return 1
    } catch (e: LibAException) {
        // the converted exception carries the original as its cause
        match (e.cause) {
            case Some(c) => return 0
            case None => return 1
        }
    }
}

// Checked exceptions (§6.2.1): rule 1 — an available capability wins and no
// conversion is considered (so adding a Convertible cannot change the meaning of
// code that already type-checks); rule 6 — a `captures` requirement is storage
// and never converts, so a capturing constructor still demands its own capability.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-FileException'

class FileException <: Exception {}
class WrapperException <: Exception {}

extend WrapperException <: Convertible<FileException, WrapperException> {
    public static func convertFrom(x: FileException): WrapperException {
        WrapperException()
    }
}

func mayFail() throws FileException {
    throw FileException()
}

// rule 1: the direct capability is used; the conversion is not considered, so the
// FileException handler (not the WrapperException one) observes the exception
func direct(): Bool {
    try {
        mayFail()
        false
    } catch (e: FileException) {
        true
    }
}

class Writer
captures FileException {
    init() {
    }

    func write(): Unit {
        throw FileException()
    }
}

// rule 6: the captures requirement is storage — the visible conversion must NOT
// satisfy it, so this construction is an error
func build(): Writer throws WrapperException {
    Writer()
}

main() {
    if (!direct()) {
        return 1
    }
    return 0
}

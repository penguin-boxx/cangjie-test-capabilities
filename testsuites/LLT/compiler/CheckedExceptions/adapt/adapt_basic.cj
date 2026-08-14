// Checked exceptions (§6.5, experimental extension): `adapt<I>(x)` produces an
// implementation of I backed by x, capturing the capabilities its methods require,
// so a clause-bearing implementation satisfies a clause-free interface.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class FileException <: Exception {}

interface Appendable {
    func append(s: String): Unit
}

// an existing implementation whose method declares a throws clause
class FileWriter {
    var count: Int64 = 0

    public func append(s: String): Unit throws FileException {
        count = count + s.size
        if (count > 100) {
            throw FileException()
        }
    }
}

func use(a: Appendable) {
    a.append("hello")
}

main() {
    let w = FileWriter()
    try {
        // adapt captures CanThrow<FileException> from this try
        let a = adapt<Appendable>(w)
        use(a)
    } catch (e: FileException) {
    }
    return 0
}

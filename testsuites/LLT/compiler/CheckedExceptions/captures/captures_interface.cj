// Checked exceptions (§3.9 / §2.1.3): capability capturing makes an implementation
// with implementation-specific exceptions conform to a clause-free interface —
// the adapter pattern, without receiver modes (pre-Modal).

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class FileException <: Exception {}

interface Appendable {
    func append(s: String): Unit // no throws clause in the interface
}

class StringAppender <: Appendable {
    public func append(s: String): Unit {
    }
}

class FileWriterAdapter <: Appendable
captures FileException {
    init() {
    }

    // overrides the clause-free interface method: needs no capabilities from
    // call sites because it uses the captured one
    public func append(s: String): Unit {
        if (s.size > 100) {
            throw FileException()
        }
    }
}

func use(a: Appendable) {
    a.append("hello") // interface users see no exceptions
}

main() {
    use(StringAppender())
    try {
        let a = FileWriterAdapter()
        use(a)
    } catch (e: FileException) {
    }
    return 0
}

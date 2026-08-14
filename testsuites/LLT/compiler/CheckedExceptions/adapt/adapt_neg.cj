// Checked exceptions (§6.5 rules 1-2): `adapt` requires the backing type to provide
// every interface method up to throws lists, and the capabilities of those methods
// must be present at the adapt call site.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error
// ASSERT: scan Cannot find a capability for 'Class-FileException'

class FileException <: Exception {}

interface Appendable {
    func append(s: String): Unit
}

class FileWriter {
    public func append(s: String): Unit throws FileException {
        throw FileException()
    }
}

class Unrelated {
    public func somethingElse(): Unit {
    }
}

// rule 2: no FileException capability in scope at the adapt site
func noCapability(): Appendable {
    adapt<Appendable>(FileWriter())
}

// rule 1: Unrelated does not provide 'append'
func notApplicable(): Appendable {
    adapt<Appendable>(Unrelated())
}

main() {
    return 0
}

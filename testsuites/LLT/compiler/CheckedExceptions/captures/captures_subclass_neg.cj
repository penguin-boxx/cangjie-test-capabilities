// Checked exceptions (§3.9 rule 5): a subclass does not see the superclass's
// captured capabilities — the synthesized field is private; it must declare its
// own `captures` clause if its methods need them.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'FileException'

class FileException <: Exception {}

open class Base
captures FileException {
    init() {
    }

    public open func write(s: String): Unit {
        throw FileException() // ok: Base's captured capability
    }
}

class Derived <: Base {
    init() {
        super()
    }

    public override func write(s: String): Unit {
        throw FileException() // error: super's capture is invisible here
    }
}

main() {
    try {
        let d = Derived()
        d.write("x")
    } catch (e: FileException) {
    }
    return 0
}

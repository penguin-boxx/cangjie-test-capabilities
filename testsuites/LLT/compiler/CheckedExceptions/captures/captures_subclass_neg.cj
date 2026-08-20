// Checked exceptions (capability capturing rule 5): a subclass does not see the superclass's
// captured capabilities — the synthesized field is private; it must declare its
// own `captures` clause if its methods need them. Its constructors do acquire the
// superclass constructor's requirements at the `super` call, which the explicit
// `throws` clause below discharges, isolating the method-body error.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-FileException'
// ASSERT: scan required by this 'throw' expression

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
    // the super call requires Base's captures; declaring them here satisfies it
    init() throws FileException {
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

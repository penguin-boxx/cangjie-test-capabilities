// Checked exceptions (capability capturing rule 4): a subclass restates coverage of the superclass's
// captured types and adds its own. Its constructor implicitly requires its own list at the call
// site, and the `super` call resolves the superclass's requirement from the class capture scope like
// any other call -- so the covering entry serves both. A more general entry covers a narrower one.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

open class FileException <: Exception {}
class MissingFileException <: FileException {}
class AuditException <: Exception {}

open class Base
captures FileException {
    init() {}

    public open func write(s: String): Unit {
        throw FileException()
    }
}

class Audited <: Base
captures AuditException, FileException {
    init() { super() }

    public override func write(s: String): Unit {
        audit(s)          // the captured AuditException capability
        super.write(s)    // and the superclass's own business
    }

    func audit(s: String): Unit {
        throw AuditException()
    }
}

// a more general entry covers the superclass's narrower one
open class Narrow
captures MissingFileException {
    init() {}
}

class Wider <: Narrow
captures FileException {
    init() { super() }
}

main(): Int64 {
    var caught = 0
    try {
        let a = Audited()   // requires AuditException and FileException here
        a.write("x")
    } catch (e: AuditException) {
        caught++
    } catch (e: FileException) {
        caught++
    }
    try {
        let w = Wider()     // requires FileException, which covers MissingFileException
        if (caught == 0) {
            return 1
        }
    } catch (e: FileException) {
    }
    return 0
}

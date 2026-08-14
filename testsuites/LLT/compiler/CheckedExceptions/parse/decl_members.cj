// Checked exceptions (§3.2): `throws` clauses on members — methods, static methods,
// constructors, property accessors, operators, interface methods, extension methods.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class MException <: Exception {}
class CreationException <: Exception {}
class GException <: Exception {}
class SException <: Exception {}

interface I {
    func m(): Int64 throws MException
}

class C <: I {
    var val: Int64 = 0

    init() throws CreationException {
        this.val = 1
    }

    init(x: Int64) throws CreationException {
        this.val = x
    }

    public func m(): Int64 throws MException {
        if (val < 0) {
            throw MException()
        }
        val
    }

    static func sm(): Unit throws AException {
        throw AException()
    }

    prop p: Int64 {
        get() throws GException {
            val
        }
    }

    mut prop q: Int64 {
        get() throws GException {
            val
        }
        set(v) throws SException {
            val = v
        }
    }

    operator func +(that: C): C throws AException, CreationException {
        // the constructor call demands a CreationException capability (M3 checking)
        C(this.val + that.val)
    }
}

extend C {
    func extMethod(): Int64 throws AException {
        if (val > 100) {
            throw AException()
        }
        val
    }
}

main() {
    try {
        let c = C(41)
        let d = C(1)
        let s = c + d
        let x = s.m() + s.p + s.extMethod()
        s.q = x
        C.sm()
    } catch (e: Exception) {
    }
    return 0
}

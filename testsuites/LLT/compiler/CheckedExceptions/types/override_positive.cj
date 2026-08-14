// Checked exceptions (§3.8): an override's throws list must be pointwise subsumed
// by the original's — subsets and subtype entries are legal.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

open class BaseException <: Exception {}
class AException <: BaseException {}
class BException <: Exception {}
class CException <: Exception {}

interface I {
    func f(): Unit throws BException, CException
    func g(): Unit throws BaseException
}

open class P {
    public open func m(): Unit throws BaseException, BException {
        throw BaseException()
    }
}

class C1 <: P & I {
    // subset of the interface's list
    public func f(): Unit throws BException {
        throw BException()
    }
    // subtype entry: AException <: BaseException
    public func g(): Unit throws AException {
        throw AException()
    }
    // override with a subset
    public override func m(): Unit throws BException {
        throw BException()
    }
}

main() {
    let c = C1()
    let i: I = c
    let p: P = c
    try {
        i.f()
    } catch (e: Exception) {
    }
    try {
        i.g()
    } catch (e: Exception) {
    }
    try {
        p.m()
    } catch (e: Exception) {
    }
    return 0
}

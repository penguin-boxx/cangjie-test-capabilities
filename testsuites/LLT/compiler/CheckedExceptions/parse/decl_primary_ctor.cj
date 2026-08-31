// Checked exceptions (capability parameters in declarations rule 1): a primary constructor may carry a `throws` clause. The
// clause must survive desugaring into the synthesized `init`, so construction sites demand it
// and the constructor's own body may discharge it.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class CreationException <: Exception {}
class FieldException <: Exception {}

func mayThrowField(): Int64 throws FieldException {
    7
}

// class primary constructor with a clause (the proposal's capability parameters in declarations example shape)
public class A {
    public A(let x: Int64) throws CreationException {
        if (x < 0) {
            throw CreationException() // discharged by the primary constructor's own clause
        }
    }
}

// struct primary constructor takes the same desugar path
public struct S {
    public S(let y: Int64) throws CreationException {
        if (y < 0) {
            throw CreationException()
        }
    }
}

// an instance field initializer's requirement must be satisfiable in every constructor's scope
public class B {
    let field: Int64 = mayThrowField()

    public B(let z: Int64) throws FieldException {
    }
}

// an authoritative empty clause on a primary constructor
public class E {
    public E(let w: Int64) throws () {
    }
}

main() {
    try {
        let a = A(1)
        let s = S(2)
        let b = B(3)
        let e = E(4)
        if (a.x + s.y + b.z + e.w != 10) {
            return 1
        }
    } catch (e: Exception) {
        return 1
    }
    return 0
}

// Checked exceptions (author ruling on Q10, 2026-08-30): a package compiled WITHOUT the feature
// ignores 'throws' in every position. The clause still parses -- the grammar is unconditional --
// but it shapes no type: '() throws E -> Unit' IS '() -> Unit', one identity, so assignment,
// invariant generic positions and calls through the value all behave as clause-free. 'throws'
// never affects overloading at any level; here it stops affecting subtyping too.

// EXEC: %compiler %cmp_opt %n.cj -o %output
// EXEC: %run %output

class OffExc <: Exception {}

class Box<T> {
    Box(let v: T) {}
}

func f(): Unit
throws OffExc {
    throw OffExc()
}

main(): Int64 {
    let w: () -> Unit = f                       // subtyping ignores the clause
    let b: Box<() -> Unit> = Box<() throws OffExc -> Unit>(f)   // identity ignores it too
    try {
        w()
        return 1
    } catch (e: OffExc) {
        try {
            b.v()
            return 1
        } catch (e2: OffExc) {
            return 0
        }
    }
}

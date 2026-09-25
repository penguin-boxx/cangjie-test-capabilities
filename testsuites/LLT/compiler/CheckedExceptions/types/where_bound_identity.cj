// Checked exceptions (semantic form, "Spelling does not create types"): "an open type parameter's
// entry is covered only when provably so -- a 'where'-bound can prove it in the open form". With
// 'E <: IOE', the list '(E, IOE)' is the list '(IOE)', so the two spellings must be one type even
// in an invariant position, where subtyping cannot help. This is the identity half of
// types/where_bound_coverage.cj, whose subtyping half was pinned first.
//
// Pinned here: identity wherever the open-form type is PRODUCED BY SUBSTITUTION -- a generic
// function's result or parameter type at a call, including a call from another generic context
// whose own parameter is still open. Substitution normalizes with the bounds attached, and the
// covered entry folds. It became true when normalization stopped asking about a type parameter
// before its bounds existed, and had no test.
//
// Still open (recorded in the gap analysis): a spelling ELABORATED directly in the open form -- a
// written annotation or a signature compared inside the generic body itself -- is normalized
// before the bounds are attached, keeps the bounded entry, and is 'mismatched types' against the
// folded spelling.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class IOE <: Exception {}
class NotFound <: IOE {}

class Box<T> {
    Box(let v: T) {}
}

// Open-form result and parameter types: the bounded parameter spelled beside its bound.
func wrap<E>(f: () throws IOE -> Unit): Box<() throws (E, IOE) -> Unit> where E <: IOE {
    Box<() throws (E, IOE) -> Unit>(f)
}

func run<E>(b: Box<() throws (IOE, E) -> Unit>): Int64 where E <: IOE {
    try {
        b.v()
        return 1
    } catch (e: IOE) {
        return 0
    }
}

// From a generic context: 'wrap<E>' substitutes one open parameter for another, bounds and all.
func fromOpen<E>(f: () throws IOE -> Unit): Int64 where E <: IOE {
    let b: Box<() throws IOE -> Unit> = wrap<E>(f)   // 'Box' is invariant: one type, or an error
    return run<E>(b)
}

main(): Int64 {
    let thrower: () throws IOE -> Unit = { => throw NotFound() }
    // At a concrete instantiation, both directions.
    let closed: Box<() throws IOE -> Unit> = wrap<NotFound>(thrower)
    return fromOpen<NotFound>(thrower) + run<NotFound>(closed)
}

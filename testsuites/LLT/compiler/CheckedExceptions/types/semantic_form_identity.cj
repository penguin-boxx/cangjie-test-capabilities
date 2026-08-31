// Checked exceptions (semantic form, "Capability parameters in declarations" rule 2): a covered
// entry is not part of the list, and that has to reach type IDENTITY, not only comparisons.
// Invariant positions are where identity is all there is: 'Box<T>' compares its argument by
// identity, so two spellings of one semantic form must be one type. Before canonicalization the
// assignment below was rejected with 'expected Box<() throws (BaseE) -> Unit>, found
// Box<() throws (BaseE, DerE) -> Unit>' -- two names for the same list.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class BaseE <: Exception {}
class DerE <: BaseE {}

class Box<T> {
    Box(let v: T) {}
}

func f(): Unit
throws BaseE, DerE {}

func g(): Unit
throws BaseE {}

main(): Int64 {
    // the redundant spelling and the canonical one are one type, both directions
    let b1: Box<() throws BaseE -> Unit> = Box<() throws (BaseE, DerE) -> Unit>(f)
    let b2: Box<() throws (BaseE, DerE) -> Unit> = Box<() throws BaseE -> Unit>(g)
    // and a duplicate spelling is the same type as its single-entry twin
    let b3: Box<() throws BaseE -> Unit> = Box<() throws (BaseE, BaseE) -> Unit>(g)
    return 0
}

// Checked exceptions ("Capability requirement at 'throw'", rule 1): a static type outside the
// 'Exception' root requires nothing -- and that applies to a type PARAMETER whose bound puts it
// there, not only to a concrete class. 'throw e' with 'E <: Error' is untracked, so an explicit
// empty clause is satisfiable; before this, such a throw demanded 'CanThrow<Generics-E>', a
// capability no 'catch' could ever supply. ('Error' cannot be subclassed outside std.core -- its
// constructors are not exported -- so the parameter is the only way to write this shape.)

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

// Under the Error root through its bound: nothing is demanded, so 'throws ()' holds.
public func failGeneric<E>(e: E): Unit
throws () where E <: Error {
    throw e
}

// The mirror: a parameter bounded by Exception still demands, proved through the same bound.
public func failChecked<E>(e: E): Unit
throws E where E <: Exception {
    throw e
}

class CheckedExc <: Exception {}

main(): Int64 {
    try {
        failChecked<CheckedExc>(CheckedExc())
    } catch (e: CheckedExc) {
        return 0
    }
    return 1
}

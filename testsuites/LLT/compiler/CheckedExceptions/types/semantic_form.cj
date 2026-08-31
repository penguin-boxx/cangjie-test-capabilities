// Checked exceptions (capability parameters in declarations, rule 2): the semantic form of a
// capability list is canonical -- a duplicate entry, or one covered by a more general entry of the
// same list, is not part of the list. Coverage-equivalent lists are therefore one and the same
// type: a value of one is assignable to the other in both directions, and an override that spells
// a covered entry is checked against the same list its supertype has.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

open class BaseException <: Exception {}
class DerivedException <: BaseException {}

func spelledWide(): Unit throws BaseException, DerivedException {
    throw DerivedException()
}

func spelledNarrow(): Unit throws BaseException {
    throw BaseException()
}

open class Producer {
    public open func make(): Unit
    throws BaseException, BaseException, DerivedException { // duplicate and covered entry
        throw BaseException()
    }
}

class Narrower <: Producer {
    // the overridden list is the semantic form {BaseException}, which this covers
    public override func make(): Unit
    throws DerivedException {
        throw DerivedException()
    }
}

main(): Int64 {
    // one type, so both assignments hold
    let wide: () throws BaseException -> Unit = spelledWide
    let narrow: () throws (BaseException, DerivedException) -> Unit = spelledNarrow
    var caught = 0
    try {
        wide()
    } catch (e: BaseException) {
        caught++
    }
    try {
        narrow()
    } catch (e: BaseException) {
        caught++
    }
    try {
        Narrower().make()
    } catch (e: BaseException) {
        caught++
    }
    if (caught == 3) {
        return 0
    }
    return 1
}

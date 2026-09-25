// Checked exceptions (functional types, "Spelling does not create types"; "Joins and meets"): entry
// order is spelling. '() throws (AE, CE) -> Unit' and '() throws (CE, AE) -> Unit' are one type, so
// they interchange in invariant positions too -- a 'Box' of one is a 'Box' of the other -- and a
// join is the same type whichever order its operands' entries came in.
//
// Before, the order of the entries was part of the interned type: the 'Box' assignment below was
// 'mismatched types', and the join of g and h came out as '(CE, AE)', so the literal of the two did
// not fit the annotation spelled '(AE, CE)'.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class AE <: Exception {}
class CE <: Exception {}

class Box<T> {
    Box(let v: T) {}
}

public func both(): Unit throws AE, CE {}
public func g(): Unit throws AE {}
public func h(): Unit throws CE { throw CE() }

main(): Int64 {
    // an invariant position, both spellings, both directions
    let b1: Box<() throws (AE, CE) -> Unit> = Box<() throws (CE, AE) -> Unit>(both)
    let b2: Box<() throws (CE, AE) -> Unit> = Box<() throws (AE, CE) -> Unit>(both)
    // the join of an array literal's elements, against an annotation in the other order
    let joined = [g, h]
    let annotated: Array<() throws (AE, CE) -> Unit> = joined
    let reversed: Array<() throws (CE, AE) -> Unit> = [h, g]
    let same: Array<() throws (AE, CE) -> Unit> = reversed
    try {
        annotated[1]()
        return 1
    } catch (e: CE) {
        return 0
    } catch (e: AE) {
        return 1
    }
}

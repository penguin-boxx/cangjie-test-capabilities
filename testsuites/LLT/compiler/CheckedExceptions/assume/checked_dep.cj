// A dependency compiled WITH checking on: its capability lists are verified, so an assumption over
// it is contradictory (see 'assume_on_checked_neg.cj').

package checked_dep

public class DepException <: Exception {}

public func risky(): Unit
throws DepException {
    throw DepException()
}

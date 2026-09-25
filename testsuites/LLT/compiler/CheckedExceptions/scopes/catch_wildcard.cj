// Checked exceptions ("Capability scopes", rule 1): a wildcard 'catch (_)' supplies
// 'CanThrow<Exception>', so it discharges every checked requirement of its 'try' block -- a
// declared one, an inferred one, and one raised by a 'throw' -- inside a declaration whose own
// list is empty. Correct since the rule was implemented, and untested until now.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class AException <: Exception {}
class BException <: Exception {}

public func declared(): Int64 throws AException { throw AException() }
func inferred(): Int64 { throw BException() }

public func wildcard(): Int64 throws () {
    try {
        declared()
    } catch (_) {
        1
    }
}

public func wildcardAfterTyped(): Int64 throws () {
    try {
        inferred() + declared()
    } catch (e: AException) {
        10
    } catch (_) {
        100
    }
}

public func wildcardOverThrow(): Int64 throws () {
    try {
        throw BException()
    } catch (_) {
        1000
    }
}

main(): Int64 {
    return if (wildcard() + wildcardAfterTyped() + wildcardOverThrow() == 1101) { 0 } else { 1 }
}

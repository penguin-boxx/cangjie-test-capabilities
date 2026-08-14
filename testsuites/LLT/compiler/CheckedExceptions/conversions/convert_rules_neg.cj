// Checked exceptions (§6.2.1): conversions are exact-From (rule 4) and do not
// chain (rule 5) — neither case may silently succeed.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-DerivedException'
// ASSERT: scan Cannot find a capability for 'Class-MidException'

open class BaseException <: Exception {}
class DerivedException <: BaseException {}
class MidException <: Exception {}
class TargetException <: Exception {}
class OtherException <: Exception {}

// rule 4: a Convertible from the BASE does not fire for a missing DERIVED capability
extend TargetException <: Convertible<BaseException, TargetException> {
    public static func convertFrom(x: BaseException): TargetException {
        TargetException()
    }
}

// rule 5: From -> Mid -> Target must not chain
extend OtherException <: Convertible<MidException, OtherException> {
    public static func convertFrom(x: MidException): OtherException {
        OtherException()
    }
}

func throwsDerived() throws DerivedException {
    throw DerivedException()
}

func throwsMid() throws MidException {
    throw MidException()
}

func exactOnly() throws TargetException {
    throwsDerived() // error: Convertible<BaseException, _> must not fire for DerivedException
}

func noChaining() throws TargetException {
    throwsMid() // error: Mid -> Other -> Target would be a chain
}

main() {
    return 0
}

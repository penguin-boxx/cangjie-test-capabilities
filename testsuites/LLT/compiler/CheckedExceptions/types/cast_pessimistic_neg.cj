// Checked exceptions (reflection and runtime casts): the pessimistic reading of a cast target is a
// real requirement -- using the cast value where nothing discharges it is an error, which is exactly
// the laundering the rule closes. The rejected targets are in types/cast_target_neg.cj.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-Exception'

class AException <: Exception {}

func throwing() throws AException {
    throw AException()
}

public func callCast(x: Any): Unit {
    // the cast hands back `() throws Exception -> Unit`: nothing here discharges it
    match (x as (() -> Unit)) {
        case Some(g) => g()
        case None => ()
    }
}

public func patternBinding(x: Any): Unit {
    match (x) {
        case g: () -> Unit => g() // same requirement through a type pattern
        case _ => ()
    }
}

main() {
    callCast(throwing)
    patternBinding(throwing)
    return 0
}

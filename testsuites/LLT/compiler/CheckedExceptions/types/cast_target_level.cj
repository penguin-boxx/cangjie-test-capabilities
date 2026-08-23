// Checked exceptions (reflection and runtime casts): rejecting a functional cast target is an
// ordinary checking violation for the exception kind, so at the 'warn' level it is a warning and
// the package still builds. A capturing type is rejected as a target for a different reason: its
// instances hold capabilities and are bound to the handlers that supplied them, which a cast result
// cannot be.

// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: '() -> Unit' cannot be a runtime cast target: it contains a function type
// ASSERT: scan warning: 'Class-Capturing' cannot be a runtime cast target: it is a capturing type

class AException <: Exception {}

class Capturing
captures AException {
    init() {}
}

func functional(x: Any): Unit {
    match (x as (() -> Unit)) { case Some(_) => (); case None => () }
}

func capturing(x: Any): Unit {
    match (x as Capturing) { case Some(_) => (); case None => () }
}

func capturingPattern(x: Any): Unit {
    match (x) {
        case _: Capturing => ()
        case _ => ()
    }
}

main() {
    return 0
}

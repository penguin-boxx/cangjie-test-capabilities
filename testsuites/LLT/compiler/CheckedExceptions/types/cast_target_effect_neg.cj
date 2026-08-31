// Checked exceptions x effect handlers: with the effect-handler feature enabled, a functional cast
// target is an error at every exception-checking level -- the value may carry a 'performs'
// component, and no pessimistic reading exists for it: there is no top command type.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '() -> Unit' cannot be a runtime cast target: it contains a function type

import stdx.effect.*

class GetNumber <: Command<Int64> {}

func functional(x: Any): Unit {
    match (x as (() -> Unit)) { case Some(_) => (); case None => () }
}

main() {
    return 0
}

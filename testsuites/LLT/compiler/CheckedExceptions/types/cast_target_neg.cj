// Checked exceptions (reflection and runtime casts): a type argument of a generic is invariant --
// CangJie has no declaration-site variance -- so a function type inside one has no sound reading and
// the target is rejected. Targets are written without clauses: the reading decides them.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan cannot be a runtime cast target: it has a function type in an invariant position
// ASSERT: scan error: a capability clause is not allowed in a runtime cast target

import std.collection.*

class AException <: Exception {}

func invariantTarget(x: Any): Unit {
    match (x as ArrayList<() -> Unit>) {
        case Some(_) => ()
        case None => ()
    }
}

func optionTarget(x: Any): Unit {
    match (x as Option<() -> Unit>) {
        case Some(_) => ()
        case None => ()
    }
}

func arrayPattern(x: Any): Unit {
    match (x) {
        case _: Array<() -> Unit> => ()
        case _ => ()
    }
}

func writtenClause(x: Any): Unit {
    match (x as (() throws AException -> Unit)) {
        case Some(_) => ()
        case None => ()
    }
}

main() {
    return 0
}

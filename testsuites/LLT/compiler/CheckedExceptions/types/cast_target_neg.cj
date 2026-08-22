// Checked exceptions (reflection and runtime casts): a runtime type test sees the erased shape, so
// nothing verifies a capability list -- reading a function type in a cast target as clause-free
// would launder the requirements of whatever value the cast accepts. The base design therefore
// rejects any cast or type-pattern target containing a function type, in any position: the target
// itself, a result, a parameter, a tuple component, a type argument. A parameter-typed target is
// accepted (rejecting it would break ordinary generic code); an instantiation with a function type
// is an unchecked boundary instead.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan cannot be a runtime cast target: it contains a function type
// ASSERT: scan error: 'Class-ArrayList<() -> Unit>' cannot be a runtime cast target
// ASSERT: scan error: 'Tuple<() -> Unit, Int64>' cannot be a runtime cast target

import std.collection.*

class AException <: Exception {}

func topLevel(x: Any): Unit {
    match (x as (() -> Unit)) { case Some(_) => (); case None => () }
}

func inResult(x: Any): Unit {
    match (x as (() -> (() -> Unit))) { case Some(_) => (); case None => () }
}

func inParameter(x: Any): Unit {
    match (x as ((() -> Unit) -> Unit)) { case Some(_) => (); case None => () }
}

func inTuple(x: Any): Unit {
    match (x as ((() -> Unit, Int64))) { case Some(_) => (); case None => () }
}

func inTypeArgument(x: Any): Unit {
    match (x as ArrayList<() -> Unit>) { case Some(_) => (); case None => () }
}

func inTypePattern(x: Any): Unit {
    match (x) {
        case _: () -> Unit => ()
        case _ => ()
    }
}

func withClause(x: Any): Unit {
    match (x as (() throws AException -> Unit)) { case Some(_) => (); case None => () }
}

// accepted: a parameter-typed target, whatever T turns out to be
func parameterTyped<T>(x: Any): Option<T> {
    x as T
}

main() {
    return 0
}

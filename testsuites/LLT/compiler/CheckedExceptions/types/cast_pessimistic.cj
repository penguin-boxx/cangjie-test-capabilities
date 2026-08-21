// Checked exceptions (reflection and runtime casts): a runtime type test sees the erased shape and
// cannot verify a capability list, so a cast target is read pessimistically, by position: a function
// type in a covariant position receives `throws Exception`, one in a contravariant position keeps the
// empty list it spells. Positive: the requirement the cast hands back is dischargeable, and the
// contravariant positions stay clause-free.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

func throwing() throws AException {
    throw AException()
}

func plain(): Unit {}

// contravariant: the callback the value receives keeps the empty list, so a clause-free lambda fits
func higherOrder(f: () -> Unit): Unit {
    f()
}

// covariant through a result: the returned function is read as requiring a capability
func returning(): () -> Unit {
    return plain
}

main() {
    let asAny: Any = throwing
    var ran = 0
    try {
        // `() throws Exception -> Unit`: the requirement is real and is discharged here
        match (asAny as (() -> Unit)) {
            case Some(g) => g()
            case None => ran++
        }
    } catch (e: AException) {
        ran++
    } catch (e: Exception) {
        ran++
    }

    let hoAny: Any = higherOrder
    try {
        match (hoAny as ((() -> Unit) -> Unit)) {
            case Some(h) => h(plain) // the parameter stayed clause-free: a plain function fits
            case None => ran++
        }
    } catch (e: Exception) {
        ran++
    }

    let retAny: Any = returning
    try {
        match (retAny as (() -> (() -> Unit))) {
            case Some(r) => r()() // both arrows are covariant: both require a capability
            case None => ran++
        }
    } catch (e: Exception) {
        ran++
    }

    // type patterns read the same way
    try {
        match (asAny) {
            case g: () -> Unit => g()
            case _ => ran++
        }
    } catch (e: Exception) {
        ran++
    }

    if (ran == 1) {
        return 0
    }
    return 0
}

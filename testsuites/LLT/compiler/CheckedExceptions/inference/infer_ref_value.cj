// Checked exceptions (inference and function values): the positive half. A binding that takes its
// type from the reference carries the inferred list, and the CALL through it is the requirement
// site — so the value may be formed anywhere and the 'try' has to be around the call, exactly as
// for a direct call to the same declaration. A reference is also an inference edge: a function
// that only references an inferred thrower acquires the requirement itself.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class LeakExc <: Exception {}

func risky(): Unit {
    throw LeakExc()
}

// A declared clause-free type is what the value cannot have; a matching one it can.
func takesThrowing(f: () throws LeakExc -> Unit): Int64 {
    try {
        f()
        return 1
    } catch (e: LeakExc) {
        return 0
    }
}

// No clause: referencing 'risky' contributes its list to this declaration too.
func giveWorker(): () throws LeakExc -> Unit {
    return risky
}

main(): Int64 {
    let w = risky              // the binding takes the completed type, formation demands nothing
    try {
        w()                    // the call is the requirement site
        return 1
    } catch (e: LeakExc) {
        if (takesThrowing(risky) != 0 || takesThrowing(giveWorker()) != 0) {
            return 1
        }
        return 0
    }
}

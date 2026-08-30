// Checked exceptions (inference and function values): the positive half of
// 'infer_ref_value_neg.cj'. Forming the value where the capability is in scope is fine, and the
// reference is an inference edge -- a function that only REFERENCES an inferred thrower acquires
// the requirement itself, exactly as a caller would.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class LeakExc <: Exception {}

func risky(): Unit {
    throw LeakExc()
}

// no clause: the reference contributes LeakExc to THIS declaration's inferred list
func giveWorker(): () -> Unit {
    risky
}

main(): Int64 {
    try {
        let w: () -> Unit = risky   // the try supplies the capability at formation
        w()
    } catch (e: LeakExc) {
        try {
            let g = giveWorker()    // giveWorker's own inferred list is supplied here
            g()
        } catch (e2: LeakExc) {
            return 0
        }
    }
    return 1
}

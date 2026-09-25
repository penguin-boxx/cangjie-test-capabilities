// Checked exceptions (inference and function values; "Joins and meets"): the positive half of
// infer_completion_neg.cj. A value derived from an inferred thrower -- through a binding, a join,
// an array or tuple literal, a subscript, an inferred result type -- carries the inferred list, so
// it fits wherever that list is admitted, and a 'try' around the CALL is what discharges it.
//
// What discriminates: a function whose result type is inferred from 'return risky' used to be
// rejected at the 'return' -- the replay compared the returned value against the result type
// type check had inferred while the list was still empty, i.e. against the clause-free type. The
// result type is inferred, so it is completed along with the value instead.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class LeakExc <: Exception {}

func risky(): Unit { throw LeakExc() }   // no clause: infers 'throws LeakExc'
func quiet(): Unit {}

func viaReturn() { return risky }        // result type inferred: '() throws LeakExc -> Unit'
func viaJoin(c: Bool) {                  // the join of a 'return' and the body's value
    if (c) {
        return risky
    }
    quiet
}

func calls(f: () throws LeakExc -> Unit): Int64 {
    try {
        f()
        return 0
    } catch (e: LeakExc) {
        return 1
    }
}

main(): Int64 {
    var caught = 0
    let cond = true
    let w = risky
    try { w() } catch (e: LeakExc) { caught++ }
    let j = if (cond) { risky } else { quiet }
    try { j() } catch (e: LeakExc) { caught++ }
    let arr = [quiet, risky]
    try { arr[1]() } catch (e: LeakExc) { caught++ }   // the element type carries the list
    let t = (risky, quiet)
    t[1]()                                       // a tuple keeps its components apart
    try { t[0]() } catch (e: LeakExc) { caught++ }
    // declared types that admit the list accept the completed values
    let admitted: Array<() throws LeakExc -> Unit> = [quiet, risky]
    let fromReturn: () throws LeakExc -> Unit = viaReturn()
    caught += calls(admitted[1]) + calls(fromReturn) + calls(viaJoin(true)) + calls(viaJoin(false))
    for (f in [risky, quiet]) {
        try { f() } catch (e: LeakExc) { caught++ }
    }
    return if (caught == 8) { 0 } else { 1 }
}

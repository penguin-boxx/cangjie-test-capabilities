// Checked exceptions (inference and function values; "Joins and meets"): an inferred list rides the
// type of every value built from the declaration -- not only of a direct reference. The list is
// completed after type check, so each type type check DERIVED from such a reference must be
// completed too: the binding it initializes and every name for that binding, the join of 'if' and
// 'match' branches, an array literal's element type, a tuple's component, a subscript into either,
// the inferred result type of a function or lambda that returns it, and a 'for-in' element. Where
// the completed value then meets a clause-free type, that is the error; where it is called, the
// call pays.
//
// Every site below compiled at 'error' and threw through 'main' before this round -- the call
// through the derived value demanded nothing, because its type still had the empty list. The
// assertions name the call or conversion site, which nothing else in the file reports.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan infer_completion_neg.cj:39:5:
// ASSERT: scan infer_completion_neg.cj:41:5:
// ASSERT: scan infer_completion_neg.cj:43:5:
// ASSERT: scan infer_completion_neg.cj:45:5:
// ASSERT: scan infer_completion_neg.cj:46:5:
// ASSERT: scan infer_completion_neg.cj:48:5:
// ASSERT: scan infer_completion_neg.cj:50:9:
// ASSERT: scan infer_completion_neg.cj:53:33:
// ASSERT: scan infer_completion_neg.cj:54:40:
// ASSERT: scan infer_completion_neg.cj:55:33:
// ASSERT: scan infer_completion_neg.cj:60:37:
// ASSERT: scan error: the inferred capability list requires 'Class-LeakExc', which the type 'Struct-Array<() -> Unit>' expected at this binding does not admit
// ASSERT: scan error: the inferred capability list requires 'Class-LeakExc', which the type '() -> Unit' expected at this result does not admit

class LeakExc <: Exception {}

func risky(): Unit { throw LeakExc() }   // no clause: infers 'throws LeakExc'
func quiet(): Unit {}

func pickLater() { risky }               // result type inferred from the reference

main(): Int64 {
    let cond = true
    let w = risky
    w()                                                  // a name for the completed binding
    let j = if (cond) { risky } else { quiet }
    j()                                                  // the join of the branches
    let m = match (cond) { case true => quiet case false => risky }
    m()                                                  // the join of the cases
    let arr = [risky, quiet]
    arr[0]()                                             // the element type of the literal
    pickLater()()                                        // an inferred result type
    let lam = { => risky }
    lam()()                                              // a lambda's inferred result type
    for (f in [quiet, risky]) {
        f()                                              // a 'for-in' element
    }
    let t = (risky, 1)
    let fromTuple: () -> Unit = t[0]                     // a tuple component
    let annotated: Array<() -> Unit> = [quiet, risky]    // an element meeting a declared type
    let viaResult: () -> Unit = pickLater()              // a result meeting a declared type
    return 0
}

// A body's value meets a declared result type as much as a 'return' does.
func implicitResult(): () -> Unit { risky }

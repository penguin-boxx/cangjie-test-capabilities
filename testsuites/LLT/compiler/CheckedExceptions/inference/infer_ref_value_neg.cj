// Checked exceptions (inference and function values): an inferred list rides the TYPE of the
// value, so a reference to an inferred thrower does not fit a clause-free functional type — and
// the call through such a value is what pays the requirement.
//
// This replaces an earlier reading where the requirement was paid where the value was FORMED.
// That reading had a hole: forming the value inside a discharging 'try' and calling it afterwards
// compiled at 'error' and threw through 'main'. Under the rule below the assignment itself is the
// error, which is where the text puts it.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: the inferred capability list requires 'Class-LeakExc', which the type '() -> Unit' expected at this binding does not admit
// ASSERT: scan error: the inferred capability list requires 'Class-LeakExc', which the type '() -> Unit' expected at this assignment does not admit
// ASSERT: scan error: the inferred capability list requires 'Class-LeakExc', which the type '() -> Unit' expected at this argument does not admit

class LeakExc <: Exception {}

func risky(): Unit {   // no clause: infers 'throws LeakExc'
    throw LeakExc()
}

func takesPlain(f: () -> Unit): Unit {
    f()
}

main(): Int64 {
    let annotated: () -> Unit = risky   // a declared clause-free type does not admit the list

    var slot: () -> Unit = { => }
    try {
        slot = risky                    // the escape the old reading let through
    } catch (e: LeakExc) {
        ()
    }
    slot()

    takesPlain(risky)                   // argument position, same rule
    return 0
}

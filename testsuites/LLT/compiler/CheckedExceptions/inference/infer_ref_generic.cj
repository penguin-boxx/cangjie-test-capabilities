// Checked exceptions (inference and function values): a reference that pins the referenced
// declaration's type arguments demands the INSTANTIATED entries. 'risky<Int64>' requires
// 'GenExc<Int64>'; demanding the uninstantiated 'GenExc<T>' made the requirement undischargeable,
// since no 'catch' can name it.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class GenExc<T> <: Exception {}

func risky<T>(): Unit {          // no clause: infers 'throws GenExc<T>'
    throw GenExc<T>()
}

main(): Int64 {
    try {
        let w = risky<Int64>     // demands GenExc<Int64>, which this try supplies
        w()
    } catch (e: GenExc<Int64>) {
        return 0
    }
    return 1
}

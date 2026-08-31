// Checked exceptions ("Joins and meets"): the meet of two lists keeps what both cover -- of two
// comparable entries, the more specific one. So a callback accepted by both branches may require
// the narrower exception, and calling the joined function with such a callback is legal.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class BaseE <: Exception {}
class DerE <: BaseE {}

func takesBase(callback: () throws BaseE -> Unit): Unit {
    try {
        callback()
    } catch (e: BaseE) {
        ()
    }
}

func takesDer(callback: () throws DerE -> Unit): Unit {
    try {
        callback()
    } catch (e: DerE) {
        ()
    }
}

main(): Int64 {
    let cond = true
    let k = if (cond) { takesBase } else { takesDer }
    // the meet of 'throws BaseE' and 'throws DerE' is 'throws DerE': the narrower one, which both
    // parameter types accept
    k({ => throw DerE() })
    return 0
}

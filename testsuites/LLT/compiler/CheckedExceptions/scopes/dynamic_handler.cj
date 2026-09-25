// Checked exceptions ("Type of exception capabilities"): a capability only witnesses that SOME
// handler is present -- the handler that runs is still chosen dynamically, by the ordinary
// exception mechanism. The text's own example: the literal is formed inside the outer 'try', whose
// capability discharges its 'throw'; it is called inside the inner 'try', and the inner handler is
// the one that runs. Correct since the feature landed, and untested until now.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

main(): Int64 {
    var ran = 0
    try {
        let f = { => throw AException() }
        try {
            f()
        } catch (e: AException) {
            ran = 1                     // this handler runs
        }
    } catch (e: AException) {
        ran = 2                         // unreachable
    }
    return if (ran == 1) { 0 } else { 1 }
}

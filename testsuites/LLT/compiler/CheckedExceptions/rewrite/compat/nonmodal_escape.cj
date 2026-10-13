// Section 6 acceptance: §6.5: no intra-function or returned-value escape rejection without Modal.
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions=error  %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
func escape(): () -> Unit throws () {
    try { return { => throw AE() } } catch (e: AE) { return { => () } }
}
main(): Int64 {
    var saved: () -> Unit = { => () }
    try { saved = { => throw AE() } } catch (e: AE) {}
    let returned = escape()
    0
}

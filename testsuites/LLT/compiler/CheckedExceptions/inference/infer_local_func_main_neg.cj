// Checked exceptions (which declarations are inferred): the negative half of
// infer_local_func_main.cj. A local function of 'main' is inferred like any other, so its 'throw'
// is not the error site -- the call is, as for a local function anywhere else; and a value formed
// from it carries the list, so it does not fit a clause-free type.
//
// What discriminates is the LOCATION: before local functions of 'main' were collected, the one
// error here was reported at the 'throw' (line 19), never at the call.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan infer_local_func_main_neg.cj:21:5:
// ASSERT: scan infer_local_func_main_neg.cj:22:29:
// ASSERT: scan error: the inferred capability list requires 'Class-AException', which the type '() -> Unit' expected at this binding does not admit
// ASSERT: scan-not infer_local_func_main_neg.cj:19:9:

class AException <: Exception {}

main(): Int64 {
    func local(): Unit {
        throw AException()          // not an error: the list is inferred
    }
    local()                         // error: nothing supplies CanThrow<AException> here
    let plain: () -> Unit = local   // error: the value carries the list
    return 0
}

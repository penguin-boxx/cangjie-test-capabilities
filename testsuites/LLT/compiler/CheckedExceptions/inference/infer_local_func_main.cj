// Checked exceptions (which declarations are inferred): "local function declarations are ordinary
// inference-eligible declarations with lists of their own" -- inside 'main' as inside any other
// body. 'main' itself is never inferred (its clause goes to the default handler), and excluding it
// used to exclude everything declared in its body as well: the local function was never collected,
// its list stayed empty, and its own 'throw' was reported with nothing to discharge it -- at the
// throw, although the only call is inside a matching 'try'. The same code inside any other function
// compiled.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

main(): Int64 {
    var caught = 0
    func local(): Unit {
        throw AException()
    }
    try {
        local()                     // the call pays the inferred list
    } catch (e: AException) {
        caught++
    }
    let value = local               // and so does a call through a value formed from it
    try {
        value()
    } catch (e: AException) {
        caught++
    }
    try {
        func nested(): Unit {       // declared inside a 'try' of 'main'
            throw AException()
        }
        nested()
    } catch (e: AException) {
        caught++
    }
    return if (caught == 3) { 0 } else { 1 }
}

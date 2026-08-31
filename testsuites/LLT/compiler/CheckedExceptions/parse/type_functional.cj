// Checked exceptions (functional types): `throws` clauses in functional types.
// Forms: parenthesised list, single-type sugar, empty list, right-associative nesting.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}
class TimeoutException <: Exception {}

func mayThrowA() throws AException {
    throw AException()
}

func mayThrowAB() throws AException, BException {
    throw BException()
}

// parenthesised list
var f1: () throws (AException, BException) -> Unit = mayThrowAB

// single capability: parens optional
var f2: () throws AException -> Unit = mayThrowA

// empty capability list: same type as omitting the clause
var f3: () throws () -> Unit = { => () }
var f4: () -> Unit = { => () }

// clause in a parameter's type
func caller(g: () throws AException -> Unit): Unit throws AException {
    g()
}

// right-associative nesting: function returning a throwing function
func mk(): () throws TimeoutException -> Unit throws () {
    { => throw TimeoutException() }
}

main() {
    try {
        caller(mayThrowA)
        f1()
        f2()
        let h: () throws TimeoutException -> Unit = mk()
        h()
    } catch (e: Exception) {
    }
    f3()
    f4()
    return 0
}

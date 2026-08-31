// Checked exceptions (capability list aliases): every element of an alias tuple must be a subtype of
// Exception and not of UncheckedException — the same rules as spelled-out entries
// (capability parameters in declarations rules 3 and 5).

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error
// ASSERT: scan is not a subtype of class 'Exception'
// ASSERT: scan unchecked exception type

class AException <: Exception {}
class NotAnException {}
class RequestException <: UncheckedException {}

type BadElement = (AException, NotAnException)
type UncheckedElement = (AException, RequestException)

func f() throws BadElement {
    throw AException()
}

func g() throws UncheckedElement {
    throw AException()
}

main() {
    return 0
}

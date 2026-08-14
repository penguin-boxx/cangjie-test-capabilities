// Checked exceptions (§3.5): a literal's capability list comes from the expected
// type only; inside such a literal those capabilities are in scope. A literal with
// no expected type has no capability parameters (its demands need enclosing scopes).

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class IOException <: Exception {}
class SomeException <: Exception {}

func withIOException<R>(f: () throws IOException -> R): R {
    try {
        return f()
    } catch (e: IOException) {
        // retry: a catch block is outside the try's capability scope, so calling f here
        // would demand an IOException capability; the recursive call requires none
        withIOException<R>(f)
    }
}

func throwsSome() throws SomeException {
    throw SomeException()
}

func test() throws SomeException {
    // expected type gives the literal a CanThrow<IOException> capability;
    // the enclosing clause covers the throwsSome() call inside it (capture)
    withIOException<Unit> {
        =>
        throwsSome()
        throw IOException()
    }
}

main() {
    try {
        test()
    } catch (e: SomeException) {
        return 0
    }
    return 1
}

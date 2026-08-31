// Checked exceptions (capability list aliases): a tuple typealias used in a `throws` clause is a
// capability list — `throws MyExceptions` means `throws A, B`.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class NetworkException <: Exception {}
class FileNotFoundException <: Exception {}
class ParseException <: Exception {}

type MyModuleExceptions = (NetworkException, FileNotFoundException)

func f() throws MyModuleExceptions {
    throw NetworkException()
}

func g() throws NetworkException, FileNotFoundException {
    throw FileNotFoundException()
}

// the alias and the spelled-out list denote the same capability list, so these
// functional types are interchangeable
func takesF(h: () throws MyModuleExceptions -> Unit): Unit throws MyModuleExceptions {
    h()
}

// an alias may be mixed with ordinary entries
func mixed() throws MyModuleExceptions, ParseException {
    throw ParseException()
}

main() {
    try {
        takesF(f)
        takesF(g)
        mixed()
    } catch (e: Exception) {
    }
    return 0
}

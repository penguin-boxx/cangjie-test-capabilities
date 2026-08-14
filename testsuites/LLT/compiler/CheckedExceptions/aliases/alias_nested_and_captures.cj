// Checked exceptions (§6.1): alias expansion is recursive (aliases may contain
// other aliases) and applies to `captures` clauses as well as `throws`.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}
class CException <: Exception {}

typealias AB = (AException, BException)
typealias ABC = (AB, CException)

func wide() throws ABC {
    throw CException()
}

// a single-element alias is a one-entry list
typealias JustA = AException
func narrow() throws JustA {
    throw AException()
}

class Worker
captures AB {
    init() {
    }

    func run(): Unit {
        throw BException() // captured through the alias
    }
}

main() {
    try {
        wide()
    } catch (e: Exception) {
    }
    try {
        narrow()
    } catch (e: AException) {
    }
    try {
        let w = Worker()
        w.run()
    } catch (e: BException) {
    }
    return 0
}

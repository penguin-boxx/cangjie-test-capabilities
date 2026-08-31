// Checked exceptions (capability list aliases): alias expansion is recursive (aliases may contain
// other aliases) and applies to `captures` clauses as well as `throws`.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}
class CException <: Exception {}

type AB = (AException, BException)
type ABC = (AB, CException)

func wide() throws ABC {
    throw CException()
}

// a single-element alias is a one-entry list
type JustA = AException
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
    // `captures AB` expands to both AException and BException, so constructing a Worker
    // demands both capabilities here
    try {
        let w = Worker()
        w.run()
    } catch (e: AException) {
    } catch (e: BException) {
    }
    return 0
}

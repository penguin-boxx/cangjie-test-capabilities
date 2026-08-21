// Checked exceptions x effect handlers: a 'captures' clause may name commands as well. An instance
// captures the handler capabilities its methods need exactly as it captures exception ones, and its
// constructor requires them at the construction site.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'
// ASSERT: scan Handler<Class-GetNumber>

import stdx.effect.*

class GetNumber <: Command<Int64> {}

class Holder captures GetNumber {
    init() {}

    // the captured handler capability is in scope in a receiver body: no clause needed
    func value(): Int64 {
        perform GetNumber()
    }
}

func makeUnhandled(): Holder {
    Holder() // error: the construction site must supply the captured handler capability
}

main() {
    try {
        let h = Holder() // ok: the handle clause below supplies it
        h.value()
    } handle (_: GetNumber) {
        resume with 42
    }
    return 0
}

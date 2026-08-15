// Effects (§8.2 with §3.7): the instantiated demand names the instantiated command type — a
// handler for a different instantiation does not discharge it.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GenCmd<Int64>'

import stdx.effect.*

class GenCmd<T> <: Command<T> {}

func gen<T>(): T performs GenCmd<T> {
    return perform GenCmd<T>()
}

public func bad(): Int64 {
    return try {
        gen<Int64>()
    } handle (_: GenCmd<Rune>) {
        resume with r'x'
    }
}

main() {
    return 0
}

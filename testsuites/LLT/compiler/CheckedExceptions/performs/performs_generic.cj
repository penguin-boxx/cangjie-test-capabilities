// Effect handlers (with overloading): a generic command in a 'performs' clause is instantiated at the
// call site, and a handler for exactly that instantiation discharges it.

// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*

class GenCmd<T> <: Command<T> {}

func gen<T>(): T performs GenCmd<T> {
    return perform GenCmd<T>()
}

main() {
    let r = try {
        gen<Int64>()
    } handle (_: GenCmd<Int64>) {
        resume with 5
    }
    if (r != 5) {
        return 1
    }
    return 0
}

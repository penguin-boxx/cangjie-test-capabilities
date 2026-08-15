// Effects (§8.2): 'perform c' requires a handler capability for the command's type, supplied by a
// 'handle' clause — the same shape as 'throw'/'catch', with 'performs' declaring the requirement.

// EXEC: %compiler %cmp_opt --experimental --enable-eh --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*

class GetNumber <: Command<Int64> {}

// the requirement is declared, so the body may perform it
func needsHandler(): Int64 performs GetNumber {
    return perform GetNumber()
}

main() {
    let r = try {
        needsHandler()
    } handle (_: GetNumber, r: Resumption<Int64>) {
        resume r with 42
    }
    if (r != 42) {
        return 1
    }
    return 0
}

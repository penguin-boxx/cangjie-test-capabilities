// Checked exceptions (interaction with an explicit throws): an explicit clause disables inference (authoritative);
// `throws A, ...` re-enables it — declared entries union with inferred ones;
// `throws ()` pins an empty list.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

func mixed(n: Int64): Int64 throws AException, ... { // A explicit, B inferred
    if (n < 0) {
        throw AException()
    }
    if (n == 7) {
        throw BException()
    }
    n
}

func pinnedEmpty(): Int64 throws () { // authoritative empty: all handled locally
    try {
        mixed(7)
    } catch (e: AException) {
        0
    } catch (e: BException) {
        0
    }
}

main() {
    try {
        let _ = mixed(1) + pinnedEmpty()
    } catch (e: AException) {
        return 1
    } catch (e: BException) {
        return 1
    }
    return 0
}

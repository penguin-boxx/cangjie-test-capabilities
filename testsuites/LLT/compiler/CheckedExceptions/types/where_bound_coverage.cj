// Checked exceptions (semantic form, revised): "coverage is subtyping provable in the
// declaration's context, `where`-bounds included" — an entry `E` with a declared bound
// `E <: IOException` is covered by `IOException` in the same list. This is the subtyping half:
// a function whose list spells both is usable wherever the covering entry alone is expected, in
// an annotated binding and in an argument position alike.
//
// The identity half — the two spellings interning as one type in an invariant position — needs
// normalization to run after the bounds are attached, and is recorded as the open half of I36.
//
// Regression value beyond the rule: normalizing a list that mentions a not-yet-bounded type
// parameter used to ask `IsSubtype(E, IOException)` during clause elaboration, before the bound
// was on the `GenericsTy` — and `IsSubtype` caches, so that one early `false` outlived the phase
// and made the bound invisible for the whole compilation.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

open class IOE <: Exception {}
class NotFound <: IOE {}

func takesNarrow(f: () throws IOE -> Unit): Int64 {
    try {
        f()
        return 1
    } catch (e: IOE) {
        return 0
    }
}

// The list spells the bounded parameter and its bound; both forms below must be accepted.
func wide<E>(f: () throws (E, IOE) -> Unit): Int64 where E <: IOE {
    let narrowed: () throws IOE -> Unit = f   // annotated binding
    return takesNarrow(f) + takesNarrow(narrowed)   // argument position
}

// Order must not matter: the list is a set.
func wideReversed<E>(f: () throws (IOE, E) -> Unit): Int64 where E <: IOE {
    return takesNarrow(f)
}

main(): Int64 {
    let thrower: () throws IOE -> Unit = { => throw NotFound() }
    if (wide<NotFound>(thrower) != 0 || wideReversed<NotFound>(thrower) != 0) {
        return 1
    }
    return 0
}

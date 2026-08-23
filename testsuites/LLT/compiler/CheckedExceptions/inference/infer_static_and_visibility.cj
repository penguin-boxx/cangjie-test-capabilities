// Checked exceptions (which declarations are inferred): the rule covers all kinds of callables, so a
// non-private static method is inferred like an instance one; and visibility is EFFECTIVE
// visibility, so a `public` method of an `internal` class -- which does not leave the module -- is
// inferred too, while a `private init` of a `public` class is inferred as well.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

class Internal {          // internal: the default
    public func exposed(): Int64 { // effectively internal, so inferred
        throw AException()
    }

    static func helper(): Int64 { // a non-private static member, inferred
        throw BException()
    }
}

public class Exposed {
    public let value: Int64

    private init(v: Int64) { // effectively private, so inferred
        value = v
        throw AException()
    }

    public static func make(): Exposed
    throws AException { // exported: written, never inferred
        Exposed(1)
    }
}

main(): Int64 {
    var caught = 0
    try {
        Internal().exposed()
    } catch (e: AException) {
        caught++
    }
    try {
        Internal.helper()
    } catch (e: BException) {
        caught++
    }
    try {
        Exposed.make()
    } catch (e: AException) {
        caught++
    }
    if (caught == 3) {
        return 0
    }
    return 1
}

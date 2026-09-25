// Checked exceptions ("What is inferred", point 2: implicit invocations): the calls the source does
// not spell out are requirement sites like any other -- an operator ('a + b'), indexing ('a[i]'), a
// compound assignment ('b += a'), the implicit 'super()' of a constructor that writes none, and a
// delegating 'this(...)'. Each is checked here in a declaration whose list is written empty, so
// each must be reported, at its own site. Correct since the rule was implemented, and untested
// until now.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan neg_implicit_calls.cj:23:46:
// ASSERT: scan neg_implicit_calls.cj:24:47:
// ASSERT: scan neg_implicit_calls.cj:25:57:
// ASSERT: scan neg_implicit_calls.cj:32:12:
// ASSERT: scan neg_implicit_calls.cj:37:31:
// ASSERT: scan Cannot find a capability for 'Class-AException'

open class AException <: Exception {}

public struct V {
    public operator func +(o: V): V throws AException { throw AException() }
    public operator func [](i: Int64): Int64 throws AException { throw AException() }
}

public func useOperator(a: V): V throws () { a + a }                       // error
public func useIndex(a: V): Int64 throws () { a[0] }                        // error
public func useCompound(a: V): V throws () { var b = a; b += a; b }         // error

public open class Parent {
    public init() throws AException { throw AException() }
}

public class ImplicitSuper <: Parent {
    public init() throws () {}                                              // error: implicit 'super()'
}

public class Delegating {
    public init(x: Int64) throws AException { throw AException() }
    public init() throws () { this(1) }                                     // error: 'this(1)'
}

main(): Int64 {
    return 0
}

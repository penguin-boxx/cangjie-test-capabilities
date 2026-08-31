// Checked exceptions (author ruling: warn level compiles and runs): an override whose list is not
// covered by the overridden declaration is a warning at this level, so the program is still built --
// and the call through the type parameter must still resolve to the implementation. Pairing an
// override with what it implements is a question about shape; a capability list takes no part in it.
// A call left on the abstract declaration would have no body behind it, which shows up only at link
// time, so this test runs the program rather than just compiling it. Both shapes are covered: a
// list the implementation declares, and one it only acquires by inference.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2> warn_out.txt
// EXEC: %run %output
// EXEC-PIPE: cat warn_out.txt | compare %f
// ASSERT: scan warning: exception type 'Class-AException' in 'throws' clause of 'write' is not covered
// ASSERT: scan warning: exception type 'Class-AException' in 'throws' clause of 'read' is not covered

class AException <: Exception {}

// F-bounded, as the platform-socket interfaces are: the type parameter is what makes the calls in
// 'Holder' direct ones rather than virtual dispatch.
interface Platform<Self> where Self <: Platform<Self> {
    func write(x: Int64): Int64
    func read(): Int64
}

class Impl <: Platform<Impl> {
    public func write(x: Int64): Int64
    throws AException {
        return x + 1
    }

    // no clause of its own: the list is inferred from the body, and exceeds the interface's
    public func read(): Int64 {
        if (false) {
            throw AException()
        }
        return 1
    }
}

class Holder<NS> where NS <: Platform<NS> {
    Holder(private let it: NS) {}

    func go(x: Int64): Int64 {
        it.write(x) + it.read()
    }
}

main(): Int64 {
    let h = Holder<Impl>(Impl())
    if (h.go(40) != 42) {
        return 1
    }
    return 0
}

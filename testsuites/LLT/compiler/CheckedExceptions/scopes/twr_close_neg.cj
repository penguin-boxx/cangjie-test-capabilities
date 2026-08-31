// Checked exceptions ("Capability scopes" rule 1): the negative half. A try-with-resources whose
// clauses do not cover what the resource's 'close()' requires must report it -- before this rule
// nothing was demanded for the implicit closing at all, so a clause-bearing 'close' ran with no
// capability anywhere (the silent-leak class).

// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: Cannot find a capability for 'Class-CloseExc'
// ASSERT: scan required by the implicit 'close()' of this resource

class CloseExc <: Exception {}
class OtherExc <: Exception {}

class Res <: Resource {
    public func isClosed(): Bool { false }
    public func close(): Unit
    throws CloseExc {
        throw CloseExc()
    }
}

public func f(): Unit
throws () {
    try (r = Res()) {          // the clause below covers OtherExc, not CloseExc
        ()
    } catch (e: OtherExc) {
        ()
    }
}

main(): Int64 { 0 }

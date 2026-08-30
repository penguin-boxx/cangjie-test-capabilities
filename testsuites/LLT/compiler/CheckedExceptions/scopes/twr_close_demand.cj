// Checked exceptions ("Capability scopes" rule 1): try-with-resources closes its resources
// implicitly, and that closing is INSIDE the try's own capability scope -- the desugaring puts it
// in a 'finally' inner to the user's catch clauses, so the same clauses catch what it throws.
// The capability pass runs before desugar, where those calls do not exist yet, so the requirement
// is synthesized for each resource. Here the try catches 'CloseExc', which discharges it; the
// negative half is 'twr_close_neg.cj'.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2> warn_out.txt
// EXEC: %run %output
// EXEC-PIPE: cat warn_out.txt | compare %f
// ASSERT: scan-not the implicit 'close()' of this resource

class CloseExc <: Exception {}

class Res <: Resource {
    public func isClosed(): Bool { false }
    public func close(): Unit
    throws CloseExc {
        throw CloseExc()
    }
}

main(): Int64 {
    try (r = Res()) {
        ()
    } catch (e: CloseExc) {
        return 0   // the closing throw is caught by this very clause
    }
    return 1
}

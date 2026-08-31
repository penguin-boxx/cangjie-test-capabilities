// Checked exceptions (What is inferred, point 2): the discriminating half of
// 'forin_protocol.cj'. A function with an authoritative empty clause iterating a sequence whose
// 'next()' throws must be rejected at the loop — before the rule, nothing was demanded for the
// iterator protocol at all, so this compiled silently and failed at run time.

// EXEC-PIPE: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan warning: Cannot find a capability for 'Class-IterExc'
// ASSERT: scan required by the 'next()' of this 'for-in'

class IterExc <: Exception {}

class ThrowingIter <: Iterator<Int64> {
    public func next(): ?Int64
    throws IterExc {
        throw IterExc()
    }
}

class ThrowingSeq <: Iterable<Int64> {
    // The return type is narrowed to the concrete iterator, so the loop sees the clause its
    // 'next()' declares. Through the interface's own clause-free 'next' nothing would be
    // demanded -- the SPI question of Q-STD-9, not this rule.
    public func iterator(): ThrowingIter {
        return ThrowingIter()
    }
}

public func iterate(): Unit
throws () {
    for (x in ThrowingSeq()) {
        ()
    }
}

main(): Int64 { 0 }

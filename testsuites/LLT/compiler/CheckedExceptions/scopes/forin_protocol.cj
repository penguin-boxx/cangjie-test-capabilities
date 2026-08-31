// Checked exceptions (What is inferred, point 2): "implicit invocations include ... the iterator
// protocol of 'for-in'". The capability pass runs before desugar, so the calls to 'iterator()'
// and 'next()' do not exist as nodes yet — they are synthesized as requirement sites, exactly as
// the implicit 'close()' of try-with-resources is. Without this a 'throws ()' function could
// iterate a throwing iterator and demand nothing at all.
//
// Here the loop's requirement is discharged by the enclosing 'try'; 'forin_protocol_neg.cj' is
// the half where it is not.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc=warn %n.cj -o %output 2> warn_out.txt
// EXEC: %run %output
// EXEC-PIPE: cat warn_out.txt | compare %f
// ASSERT: scan-not the 'next()' of this 'for-in'

class IterExc <: Exception {}

class ThrowingIter <: Iterator<Int64> {
    private var produced = 0
    public func next(): ?Int64
    throws IterExc {
        produced++
        if (produced > 2) {
            throw IterExc()
        }
        return Some(produced)
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

main(): Int64 {
    var seen = 0
    try {
        for (x in ThrowingSeq()) {
            seen++
        }
        return 1
    } catch (e: IterExc) {
        if (seen != 2) {
            return 1
        }
        return 0
    }
}

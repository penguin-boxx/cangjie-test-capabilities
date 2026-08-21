// Checked exceptions (capability scopes): no capability scope encloses a finalizer. It is therefore
// not inference-eligible -- a checked throw inside one has nothing to discharge it -- and the
// captured capabilities of a capturing class do not reach it either. The clause side of the rule is
// in parse/neg_finalizer_clause.cj.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-BException'
// ASSERT: scan Cannot find a capability for 'Class-CException'

class BException <: Exception {}
class CException <: Exception {}

func mkB() throws BException {
    throw BException()
}

func mkC() throws CException {
    throw CException()
}

class Inferred {
    ~init() { // error: a finalizer is not inference-eligible, so nothing discharges mkB
        mkB()
    }
}

class Capturing captures CException {
    init() {}

    func use() {
        mkC() // ok: a receiver body is covered by the captures scope
    }

    ~init() { // error: the captured capability does not reach a finalizer
        mkC()
    }
}

main() {
    return 0
}

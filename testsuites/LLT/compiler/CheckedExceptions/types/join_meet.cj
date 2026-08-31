// Checked exceptions ("Joins and meets"): where the language computes a common supertype of
// functional types componentwise, the capability component of the JOIN is the union of the lists
// in semantic form; the MEET -- which the join's parameter positions require by contravariance --
// keeps the entries both lists cover, so unrelated entries contribute nothing and the common
// parameter type is requirement-free. Both examples are the text's own.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan found '() throws (Class-AException, Class-BException) -> Unit'
// ASSERT: scan found '(() -> Unit) -> Unit'

class AException <: Exception {}
class BException <: Exception {}

func g(): Unit throws AException {}
func h(): Unit throws BException {}

func p(callback: () throws AException -> Unit): Unit {}
func q(callback: () throws BException -> Unit): Unit {}

main(): Int64 {
    let cond = true
    // join: the union of the two lists
    let f = if (cond) { g } else { h }
    let showJoin: Int64 = f
    // meet: unrelated entries have no common subtype, so the parameter is requirement-free
    let k = if (cond) { p } else { q }
    let showMeet: Int64 = k
    return 0
}

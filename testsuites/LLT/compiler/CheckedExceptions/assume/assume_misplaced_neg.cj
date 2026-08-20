// Checked exceptions (assumption imports): the annotation only means anything on an import, where the trust
// relationship lives. Anywhere else it would be silently inert, so it is rejected.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan '@AssumeThrows' is only allowed on an 'import'

class SqlException <: Exception {}

@AssumeThrows[SqlException]
public func f(): Int64 {
    0
}

main() {
    return 0
}

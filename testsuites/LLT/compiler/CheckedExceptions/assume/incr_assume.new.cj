@AssumeThrows[OtherExc]
import legacy_db.*

class SqlExc <: Exception {}
class OtherExc <: Exception {}

// public: no inference, so the assumed requirement must be discharged here.
// This file and the .new one differ in the annotation token and NOTHING else:
// same lines, same declarations, so only the assumption can invalidate the cache.
public func run(): Int64 {
    try {
        return query("x")
    } catch (e: SqlExc) {
        return 0
    }
}

main() {
    return 0
}

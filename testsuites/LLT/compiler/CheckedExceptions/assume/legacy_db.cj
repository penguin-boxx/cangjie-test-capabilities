// Support package for the assumption-import tests: an "unchecked" dependency, compiled without
// --enable-checked-exceptions, that declares no throws clauses.

package legacy_db

public func query(sql: String): Int64 {
    sql.size
}

public class Connection {
    public init() {
    }

    public func execute(sql: String): Int64 {
        sql.size
    }
}

// Support package for the cross-package tests (package metadata): a CHECKED dependency whose
// public surface carries 'throws' clauses. Compiled with --enable-checked-exceptions, so its
// capability lists must survive into the .cjo and be demanded at call sites in other packages.

package libx

public class XException <: Exception {}
public class YException <: Exception {}
public class GenException<T> <: Exception {}

public func query(sql: String): Int64 throws XException {
    if (sql.size == 0) {
        throw XException()
    }
    return sql.size
}

public func clean(): Int64 throws () {
    return 1
}

public func generic<T>(x: T): Int64 throws GenException<T> {
    return 1
}

public class Connection {
    public init() {
    }

    public func execute(sql: String): Int64 throws XException {
        return sql.size
    }

    public prop status: Int64 {
        get() throws YException {
            0
        }
    }
}

// A public signature carrying a functional type with a clause (functional types): the clause is part
// of the parameter's TYPE, so it must survive in the .cjo nested inside that type.
public func withCallback(cb: () throws XException -> Int64): Int64 throws XException {
    return cb()
}

// A capturing class (capability capturing): construction demands the captured capabilities, so the
// 'captures' clause must cross the boundary as well.
public class Session captures XException {
    public init() {
    }

    public func run(): Int64 {
        throw XException()
    }
}

// Proposal 3.10.2 rule 1: the exported list is canonical — subsumed entries dropped. 'SubExc' is
// covered by 'BaseExc', so importers see 'BaseExc' alone.
public open class BaseExc <: Exception {}
public class SubExc <: BaseExc {}

public func subsumed(): Int64 throws SubExc, BaseExc {
    return 1
}

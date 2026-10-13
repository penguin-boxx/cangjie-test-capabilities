package r6warn
public class AE <: Exception {}
public func violates(): Unit { throw AE() }
public func declared(): Int64 throws AE { 9 }

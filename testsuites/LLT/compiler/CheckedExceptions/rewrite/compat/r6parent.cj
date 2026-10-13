package r6parent
public class AE <: Exception {}
internal func inferred(): Unit { throw AE() }
public func visible(): Int64 { 1 }

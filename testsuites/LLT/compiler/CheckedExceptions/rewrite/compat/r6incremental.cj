class AE <: Exception {}
public func caller(): Unit { throw AE() }
main(): Int64 { 0 }

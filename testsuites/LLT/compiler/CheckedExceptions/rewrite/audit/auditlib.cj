// Support package for serialized_inferred_alias*.cj; no standalone test commands.
package auditlib
public class AE <: Exception {}
public class BE <: Exception {}
public type Errors = (AE, (BE, AE))
func hidden(flag: Bool): Unit { if (flag) { throw AE() }; throw BE() }
public func factory() { hidden }
public func aliased(): Unit throws Errors {}

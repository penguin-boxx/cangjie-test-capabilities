package auditalias
class AE <: Exception {}
class BE <: Exception {}
type Errors = (AE, BE)
func declared(): Unit throws Errors {}
public func caller(): Unit {
    try { declared() } catch (e: AE) {}
}
main(): Int64 { caller(); 0 }

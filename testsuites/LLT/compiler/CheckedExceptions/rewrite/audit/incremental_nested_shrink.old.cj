package auditnestedshrink
class AE <: Exception {}
func parent(): Unit {
    func unused(): Unit { throw AE() }
}
func factory() { parent }
func caller(): Unit throws () {
    let callback: () -> Unit = factory()
    callback()
}
main(): Int64 { caller(); 0 }

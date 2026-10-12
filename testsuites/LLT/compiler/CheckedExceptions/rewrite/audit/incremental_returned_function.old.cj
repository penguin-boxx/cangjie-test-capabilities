package auditincr
class AE <: Exception {}
func risky(): Unit { () }
func factory() { risky }
func caller(): Unit throws () {
    let callback: () -> Unit = factory()
    callback()
}
main(): Int64 { caller(); 0 }

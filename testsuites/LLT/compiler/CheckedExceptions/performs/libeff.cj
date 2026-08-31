// Support package for the cross-package effect tests: a checked dependency whose public surface
// carries a 'performs' clause, so the effect requirement must cross through the .cjo.

package libeff

import stdx.effect.*

public class GetToken <: Command<Int64> {}

public func fetch(): Int64 performs GetToken {
    return perform GetToken()
}

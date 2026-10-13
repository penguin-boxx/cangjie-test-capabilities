package r6genericbounds

import stdx.effect.*

public open class Ask <: Command<Int64> {}

public func retain<C, R>(f: () performs C -> R): () performs C -> R where C <: Ask {
    f
}

export BIFM, BIFMMeta

struct BIFM end

@node BIFM Deterministic [ output, input, zprev, znext ]

mutable struct BIFMMeta{T}
    A :: Matrix{T}
    B :: Matrix{T}
    C :: Matrix{T}
    H :: Union{Matrix{T}, Nothing}
    ξztilde :: Union{Vector{T}, Nothing}
    Wz :: Union{Matrix{T}, Nothing}
    μu :: Union{Matrix{T}, Nothing}
    Σu :: Union{Matrix{T}, Nothing}
end

function BIFMMeta(A::Array{T1, 2}, B::Array{T2, 2}, C::Array{T3, 2}) where { T1, T2, T3 }
    T = promote_type(T1, T2, T3)
    # check whether the dimensionality of transition matrices makes sense
    @assert size(A,1) == size(B,1)
    @assert size(A,1) == size(C,2)

    # return default Meta data for BIFM node
    return BIFMMeta{T}(A, B, C, nothing, nothing, nothing, nothing, nothing)
end

getA(meta::BIFMMeta)                = meta.A
getB(meta::BIFMMeta)                = meta.B
getC(meta::BIFMMeta)                = meta.C
getH(meta::BIFMMeta)                = meta.H
getξztilde(meta::BIFMMeta)          = meta.ξztilde
getWz(meta::BIFMMeta)               = meta.Wz
getμu(meta::BIFMMeta)               = meta.μu
getΣu(meta::BIFMMeta)               = meta.Σu

function setH!(meta::BIFMMeta, H)
    meta.H = H
end

function setξztilde!(meta::BIFMMeta, ξztilde)
    meta.ξztilde = ξztilde
end

function setWz!(meta::BIFMMeta, Wz)
    meta.Wz = Wz
end

function setμu!(meta::BIFMMeta, μu)
    meta.μu = μu
end

function setΣu!(meta::BIFMMeta, Σu)
    meta.Σu = Σu
end


default_meta(::Type{ BIFM }) = error("BIFM node requires meta flag explicitly specified")

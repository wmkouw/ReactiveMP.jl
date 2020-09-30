export datavar

mutable struct DataVariableProps
    messagein :: Union{Nothing, LazyObservable{Message}}
    marginal  :: Union{Nothing, MarginalObservable}

    DataVariableProps() = new(nothing, nothing)
end

struct DataVariable{S, D} <: AbstractVariable
    name       :: Symbol
    messageout :: S
    props      :: DataVariableProps
end

function datavar(name::Symbol, ::Type{D}; subject::S = Subject(Message{D})) where { S, D }
    return DataVariable{S, D}(name, subject, DataVariableProps())
end

degree(::DataVariable) = 1

getlastindex(::DataVariable) = 1

function messageout(datavar::DataVariable, index::Int)
    @assert index === 1
    return datavar.messageout
end

function messagein(datavar::DataVariable, index::Int)
    @assert index === 1
    return datavar.props.messagein
end

update!(datavar::DataVariable, data)                 = next!(messageout(datavar, 1), as_message(data))
update!(datavar::DataVariable, data::Real)           = next!(messageout(datavar, 1), as_message(Dirac(data)))
update!(datavar::DataVariable, data::AbstractVector) = next!(messageout(datavar, 1), as_message(Dirac(data)))
update!(datavar::DataVariable, data::AbstractMatrix) = next!(messageout(datavar, 1), as_message(Dirac(data)))

finish!(datavar::DataVariable)       = complete!(messageout(datavar, 1))

_getmarginal(datavar::DataVariable)                                = datavar.props.marginal
_setmarginal!(datavar::DataVariable, marginal::MarginalObservable) = datavar.props.marginal = marginal
_makemarginal(datavar::DataVariable)                               = datavar.messageout |> map(Marginal, as_marginal)

function setmessagein!(datavar::DataVariable, index::Int, messagein)
    @assert index === 1 && datavar.props.messagein === nothing
    datavar.props.messagein = messagein
    return nothing
end
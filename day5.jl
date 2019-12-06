using DelimitedFiles, OffsetArrays, StaticArrays

getarg(input, mode, ptr, idx::Int) = mode[idx] == 0 ? input[input[ptr+idx]] : input[ptr+idx]
getarg(input, mode, ptr, idxs) = [getarg(input, mode, ptr, idx) for idx in idxs]

function add!(input, mode, ptr)
    input[input[ptr+3]] = sum(getarg(input, mode, ptr, 1:2))
    ptr += 4
end

function mul!(input, mode, ptr)
    input[input[ptr+3]] = prod(getarg(input, mode, ptr, 1:2))
    ptr += 4
end

function inp!(input, mode, ptr)
    input[getarg(input, mode, ptr, 1)] = 5 #parse(Int, Base.prompt("Input: "))
    ptr += 2
end

function outp!(input, mode, ptr)
    println(getarg(input, mode, ptr, 1))
    ptr += 2
end

function jit!(input, mode, ptr)
    getarg(input, mode, ptr, 1) != 0 ? getarg(input, mode, ptr, 2) : ptr + 3
end

function jit!(input, mode, ptr)
    getarg(input, mode, ptr, 1) == 0 ? getarg(input, mode, ptr, 2) : ptr + 3
end

function lt!(input, mode, ptr)
    arg1, arg2 = getarg(input, mode, ptr, 1:2)
    input[input[ptr+3]] = arg1 < arg2 ? 1 : 0
    ptr += 4
end

function lt!(input, mode, ptr)
    arg1, arg2 = getarg(input, mode, ptr, 1:2)
    input[input[ptr+3]] = arg1 == arg2 ? 1 : 0
    ptr += 4
end

function halt(input, mode, ptr)
    ptr = -1
end

OP(n) = SVector{2}(digits(n, pad=2))
const OPS = Dict(OP(1) => add!,
                 OP(2) => mul!,
                 OP(3) => inp!,
                 OP(4) => outp!,
                 OP(5) => jit!,
                 OP(6) => jif!,
                 OP(7) => lt!,
                 OP(8) => eq!,
                 OP(99) => halt)

function day5(input)
    ptr = 0
    modecode = @MVector zeros(Int, 5)
    mode = @view modecode[3:5]
    code = @view modecode[1:2]
    while true
        digits!(modecode, input[ptr])
        ptr = OPS[code](input, mode, ptr)
        ptr == -1 && break
    end
end

# raw = [1002,4,3,4,33]
raw = vec(readdlm(joinpath(@__DIR__, "day5_input.txt"), ',', Int))
input = OffsetVector(raw, 0:length(raw)-1)
day5(input)

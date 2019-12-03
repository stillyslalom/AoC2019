using DelimitedFiles, OffsetArrays

function day2!(raw)
    input = OffsetVector(raw, 0:length(raw)-1)
    for idx in 0:4:length(input)-1
        op = input[idx]
        op == 99 && break
        p1, p2, p3 = input[idx+1:idx+3]
        input[p3] = op == 1 ? input[p1] + input[p2] : input[p1] * input[p2]
    end
    return input
end

# part 1
raw = vec(readdlm(joinpath(@__DIR__, "day2_input.txt"), ',', Int))
raw[2:3] = [12, 2]
day2!(raw)

# part 2
raw = vec(readdlm(joinpath(@__DIR__, "day2_input.txt"), ',', Int))
function day2_part2(raw)
    for noun in 0:99, verb in 0:99
        raw2 = copy(raw)
        raw2[2:3] = [noun, verb]
        day2!(raw2)[0] == 19690720 && return (noun, verb)
    end
end

noun, verb = day2_part2(raw)
100*noun + verb

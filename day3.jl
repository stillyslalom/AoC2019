using DelimitedFiles

function tracewires(input)
    path_x, path_y = [StepRange(0:0)], [StepRange(0:0)] # init w/ dummy wires
    for leg in input
        dir, len = leg[1], parse(Int, leg[2:end])
        x0, y0 = path_x[end][end], path_y[end][end]
        if dir == 'U'
            push!(path_x, x0:x0)
            push!(path_y, y0 .+ (0:len))
        elseif dir == 'D'
            push!(path_x, x0:x0)
            push!(path_y, y0 .- (0:len))
        elseif dir == 'R'
            push!(path_x, x0 .+ (0:len))
            push!(path_y, y0:y0)
        elseif dir == 'L'
            push!(path_x, x0 .- (0:len))
            push!(path_y, y0:y0)
        end
    end
    popfirst!(path_x), popfirst!(path_y) # remove dummy wires
    return path_x, path_y
end

function wirecrosses(w1, w2)
    x1, y1 = tracewires(w1)
    x2, y2 = tracewires(w2)
    w1len = 0 # wire 1 length accumulator
    intersections = Vector{Tuple{Int,Int}}()
    sumlen = Int[]
    for i in eachindex(x1)
        w2len = 0 # wire 2 length accumulator
        for j in eachindex(x2)
            intx = x1[i] ∩ x2[j]
            inty = y1[i] ∩ y2[j]
            if length(intx) > 0 && length(inty) > 0
                for x in intx, y in inty
                    w1_intlen = abs(x - x1[i][1]) + abs(y - y1[i][1])
                    w2_intlen = abs(x - x2[j][1]) + abs(y - y2[j][1])
                    push!(sumlen, w1len + w2len + w1_intlen + w2_intlen)
                    push!(intersections, (x, y))
                end
            end
            w2len += length(x2[j]) + length(y2[j]) - 2
        end
        w1len += length(x1[i]) + length(y1[i]) - 2
    end
    return intersections, sumlen
end

minhattan(intersections) = minimum([abs(x) + abs(y) for (x, y) in intersections[2:end]])

function day3(input)
    w1, w2 = split.(input, ',')
    intersections, sumlen = wirecrosses(w1, w2)
    mindist = minhattan(intersections)
    return mindist, minimum(sumlen[2:end])
end

input = readdlm(joinpath(@__DIR__, "day3_input.txt"))
day3(input)

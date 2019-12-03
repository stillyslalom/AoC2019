using DelimitedFiles

# fuel(mass) = mass ÷ 3 - 2 # part 1
fuel(mass) = mass < 9 ? 0 : mass ÷ 3 - 2 + fuel(mass ÷ 3 - 2) # part 2

modules = Int.(readdlm(joinpath(@__DIR__, "day1_input.txt")))

sum(fuel, modules)

fuel(100756)

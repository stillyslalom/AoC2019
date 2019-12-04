function checknumber_part1(n)
    ndigits = digits(n)
    issorted(ndigits, rev=true) && !allunique(ndigits)
end

function checknumber_part2(n)
    ndigits = digits(n)
    (issorted(ndigits, rev=true)
     && !allunique(ndigits)
     && any(==(2), sum(unique(ndigits)' .== ndigits, dims=1)))
end

n1, n2 = 284639, 748759
count(n -> checknumber_part1(n), n1:n2)
count(n -> checknumber_part2(n), n1:n2)

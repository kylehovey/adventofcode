module Day8

using Revise
using LinearAlgebra

lookup = eachcol(I(7)) |> collect
a, b, c, d, e, f, g = lookup
segments = hcat([
  a + b + c + e + f + g,
  c + f,
  a + c + d + e + g,
  a + c + d + f + g,
  b + c + d + f,
  a + b + d + f + g,
  a + b + d + e + f + g,
  a + c + f,
  a + b + c + d + e + f + g,
  a + b + c + d + f + g
]...)

function digitize(serialization)
  [lookup[Int(c) - 96] for c in serialization] |> sum
end

function parseInput()
  split.(readlines("./input.txt"), " | ") .|>
    x -> split.(x, " ") .|>
    digits -> digitize.(digits)
end

function partOne()
  counts = Iterators.flatten(parseInput() .|> x -> x[2] .|> sum) |> collect
  isChosen = x -> x == 2 || x == 3 || x == 4 || x == 7
  counts[isChosen.(counts)] |> length
end

end # module

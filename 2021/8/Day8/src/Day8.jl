module Day8

using Revise
using LinearAlgebra
using IterTools

lookup = eachcol(I(7)) |> collect
a, b, c, d, e, f, g = lookup
normalDigits = hcat([
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
rotOne = I(10)[:, [1,2,3,6,4,5,7,8,9,10]]
rotTwo = I(10)[:, [1,2,3,4,5,6,9,7,8,10]]

function digitize(serialization)
  [lookup[Int(c) - 96] for c in serialization] |> sum
end

function parseInput()
  split.(readlines("./test.txt"), " | ") .|>
    x -> split.(x, " ") .|>
    digits -> digitize.(digits)
end

function partOne()
  counts = Iterators.flatten(parseInput() .|> x -> x[2] .|> sum) |> collect
  isChosen = x -> x ∈ (2, 3, 4, 7)
  counts[isChosen.(counts)] |> length
end

function sortedByColumnLength(D)
  D[:, sortperm(eachcol(D) .|> sum)]
end

sortedNormalDigits = sortedByColumnLength(normalDigits)
Pi = pinv(sortedNormalDigits)

function defuck(A, epsilon = 0.2)
  A[A.<=(epsilon)] .= 0
  A[A.>(epsilon)] .= 1
  A
end

function parseLine((input, output))
  D = hcat(input...)
  O = hcat(output...)
  Ds = sortedByColumnLength(D)

  for (i, j) ∈ IterTools.product(1:3, 1:3)
    Dsp = Ds * rotOne^i * rotTwo^j

    if defuck((Dsp * Pi) * sortedNormalDigits) ≈ Dsp
      unscrambled = Int.(round.(inv(Dsp * Pi) * O))
      digitCols = eachcol(normalDigits) |> collect

      outputDigits = eachcol(unscrambled) .|>
        col -> first(findall(==(col), digitCols))

      return (0:3 .|> k -> (outputDigits[4-k] - 1) * 10^k) |> sum
    end
  end
end

function partTwo()
  parseInput() .|> parseLine
end

end # module

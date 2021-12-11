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
  [lookup[Int(c) - Int('a') + 1] for c in serialization] |> sum
end

function getDigits()
  split.(readlines("./input.txt"), " | ") .|>
    x -> split.(x, " ") .|>
    digits -> digitize.(digits)
end

function partOne()
  counts = Iterators.flatten(getDigits() .|> x -> x[2] .|> sum) |> collect
  isChosen = x -> x ∈ (2, 3, 4, 7)
  counts[isChosen.(counts)] |> length
end

function sortedByColumnLength(D)
  D[:, sortperm(eachcol(D) .|> sum)]
end

sortedNormalDigits = sortedByColumnLength(normalDigits)
Pi = pinv(sortedNormalDigits)

function parseLine((input, output))
  D = hcat(input...)
  O = hcat(output...)
  Ds = sortedByColumnLength(D)

  for (i, j) ∈ IterTools.product(1:3, 1:3)
    Dsp = Ds * rotOne^i * rotTwo^j

    if (Dsp * Pi) * sortedNormalDigits ≈ Dsp
      unscrambled = Int.(round.(inv(Dsp * Pi) * O))
      digitCols = eachcol(normalDigits) |> collect

      outputDigits = eachcol(unscrambled) .|>
        col -> first(findall(==(col), digitCols))

      return (0:3 .|> k -> (outputDigits[4-k] - 1) * 10^k) |> sum
    end
  end
end

function partTwo()
  getDigits() .|> parseLine
end

function numerize(serialization)
  [2^(Int(c) - Int('a')) for c in serialization] |> sum
end

function digitMap(input)
  input_sorted = sort(input, by=count_ones)

  _one, _seven, _four, _eight = input_sorted[[1,2,3,10]]

  twoFiveThree = input_sorted[4:6]
  zeroSixNine = input_sorted[7:9]

  (_nine) = first(Iterators.Filter(x -> x & _four == _four, zeroSixNine))
  (_zero) = first(Iterators.Filter(x -> x & _one == _one && x != _nine, zeroSixNine))
  (_six) = first(Iterators.Filter(x -> x ∉ (_nine, _zero), zeroSixNine))

  (_three) = first(Iterators.Filter(x -> x & _one == _one, twoFiveThree))
  (_five) = first(Iterators.Filter(x -> count_ones(x & _six) == 5, twoFiveThree))
  (_two) = first(Iterators.Filter(x -> x ∉ (_three, _five), twoFiveThree))

  return Dict(
    _zero => 0,
    _one => 1,
    _two => 2,
    _three => 3,
    _four => 4,
    _five => 5,
    _six => 6,
    _seven => 7,
    _eight => 8,
    _nine => 9
  )
end

function partTwoEasy()
  rows = split.(readlines("./input.txt"), " | ") .|>
    x -> split.(x, " ") .|>
    digits -> numerize.(digits)

  outSum = 0

  for row ∈ rows
    (input, output) = row
    mapping = digitMap(input)
    unscrambledOutput = output .|> x -> mapping[x]
    outSum += (0:3 .|> k -> unscrambledOutput[4-k] * 10^k) |> sum
  end

  return outSum
end

end # module

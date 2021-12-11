module Day9

using Revise
using Memoize

function parseInput()
  lines = readlines("./input.txt") .|>
    line -> split(line, "") .|>
    char -> parse(Int, char)

  hcat(lines...)'
end

function partOne()
  A = parseInput()
  β = typemax(Int)
  display(A)
  m, n = size(A)
  kernel = [(2, 1), (1, 2), (3, 2), (2, 3)] .|> CartesianIndex
  padded = [
    zeros(Int, (1, n + 2)) .+ β;
    zeros(Int, (m, 1)) .+ β A zeros(Int, (m, 1)) .+ β;
    zeros(Int, (1, n + 2)) .+ β
  ]

  function riskLevelOf((i, j))
    height = A[i, j]
    if all(>(height), padded[i:(i+2), j:(j+2)][kernel])
      return height + 1
    end

    return 0
  end

  Iterators.product(1:m, 1:n) .|> riskLevelOf |> sum
end

@memoize function basinOf(A, (i, j))
  height = A[i, j]

  for (x, y) ∈ [(1, 0), (-1, 0), (0, 1), (0, -1)]
    u, v = i + x, j + y
    if checkbounds(Bool, A, u, v) && A[u, v] < height && A[u, v] != 9
      return basinOf(A, (u, v))
    end
  end

  return (i, j)
end

function partTwo()
  A = parseInput()
  m, n = size(A)

  function basinOrWall((i, j))
    if A[i, j] == 9
      return nothing
    end

    basinOf(A, (i, j))
  end

  B = zeros(Int, (m, n))

  for maybeBasin ∈ Iterators.product(1:m, 1:n) .|> basinOrWall
    if !isnothing(maybeBasin)
      (i, j) = maybeBasin
      B[i, j] += 1
    end
  end

  reverse(sort(B[B .!= 0]))[1:3] |> prod
end

end # module

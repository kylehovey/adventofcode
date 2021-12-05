module Day5

using Revise

struct Line
  from::Tuple{Int, Int}
  to::Tuple{Int, Int}
end

function lineFromCoords((first, last))
  Line(Tuple(x + 1 for x in first), Tuple(x + 1 for x in last))
end

function parseInput()
  input = readlines("./input.txt") |>
    lst -> map(line -> split(line, " -> "), lst) |>
    lst -> map(
      coords -> map(
        coord -> map(
          x -> parse(Int, x),
          split(coord, ",")
        ),
        coords
      ),
      lst
    ) |>
    lst -> map(lineFromCoords, lst)

  input
end

function gridDimensions((line, lines...)::Array{Line}, (χ, γ) = (0, 0))
  x, y = line.from
  X, Y = line.to
  nextDims = (max(x, X, χ), max(y, Y, γ))

  if length(lines) == 0
    return nextDims
  end

  return gridDimensions(lines, nextDims)
end

function ventMap((line, lines...)::Array{Line}, grid)
  x, y = line.from
  X, Y = line.to

  if x == X
    grid[x, min(y, Y):max(y, Y)] .+= 1
  elseif y == Y
    grid[min(x, X):max(x, X), y] .+= 1
  else
    dX, dY = line.to .- line.from
    coords = zip([0:dX; 0:-1:dX], [0:dY; 0:-1:dY]) |>
      lst -> map(dV -> line.from .+ dV, lst) |>
      lst -> map(pair -> CartesianIndex(pair), lst)

    grid[coords] .+= 1
  end

  if length(lines) == 0
    return grid
  end

  return ventMap(lines, grid)
end

function main()
  lines = parseInput()
  grid = zeros(Int, gridDimensions(lines))

  vents = ventMap(lines, grid)

  length(vents[vents .> 1])
end

end # module

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
  readlines("./input.txt") .|>
    line -> split(line, " -> ") .|>
    lst -> lst .|>
    s -> (split(s, ",") .|> x -> parse(Int, x)) .|>
    lineFromCoords
end

function ventMap((line, lines...)::Array{Line}, grid)
  x, y = line.from
  X, Y = line.to

  if x == X || y == Y
    grid[min(x, X):max(x, X), min(y, Y):max(y, Y)] .+= 1
  else
    dX, dY = line.to .- line.from
    coords = zip([0:dX; 0:-1:dX], [0:dY; 0:-1:dY]) .|> dV -> line.from .+ dV
    grid[coords .|> CartesianIndex] .+= 1
  end

  if length(lines) == 0 return grid

  return ventMap(lines, grid)
end

function main()
  grid = zeros(Int, (1000, 1000))
  vents = ventMap(parseInput(), grid)
  length(vents[vents .> 1])
end

end # module

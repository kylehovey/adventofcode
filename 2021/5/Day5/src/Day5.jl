module Day5

using Revise

function parseInput()
  readlines("./input.txt") .|>
    line -> split(line, " -> ") .|>
    lst -> lst .|>
    s -> Tuple(split(s, ",") .|> x -> parse(Int, x) + 1)
end

function ventMap(((from, to), lines...), grid)
  (x, y), (X, Y) = from, to
  dX, dY = to .- from

  if dX == 0 || dY == 0
    grid[min(x, X):max(x, X), min(y, Y):max(y, Y)] .+= 1
  else
    coords = zip([0:dX; 0:-1:dX], [0:dY; 0:-1:dY]) .|> dV -> from .+ dV
    grid[coords .|> CartesianIndex] .+= 1
  end

  if isempty(lines)
    return
  end

  ventMap(lines, grid)
end

function main()
  grid = zeros(Int, (1000, 1000))
  ventMap(parseInput(), grid)
  length(grid[grid .> 1])
end

end # module

module Day7

using Revise
using Statistics

function parseInput()
  parse.(Int, split(readline("./input.txt"), ","))
end

end # module

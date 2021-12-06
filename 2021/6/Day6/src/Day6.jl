module Day6

using Revise

function parseInput()
  feesh = split(readline("./input.txt"), ",") .|> x -> parse(Int, x)
  0:8 .|> x -> count(f -> f == x, feesh)
end

function nextAquarium(aquarium)
  nextOne = circshift(aquarium, -1)
  nextOne[7] += aquarium[1]
  nextOne
end

function aquariumAfter(days, aquarium)
  if days == 0
    return aquarium
  end

  return aquariumAfter(days - 1, nextAquarium(aquarium))
end

function main()
  println(aquariumAfter(80, parseInput()) |> sum)
  println(aquariumAfter(256, parseInput()) |> sum)
end

end # module

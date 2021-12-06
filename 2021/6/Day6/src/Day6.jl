module Day6

using Revise

function parseInput()
  split(readline("./input.txt"), ",") .|> x -> parse(Int, x)
end

function nextFish(fish)
  fish == 0 ? [6, 8] : [fish - 1]
end

function nextAquarium(aquarium)
  Iterators.flatten(map(nextFish, aquarium)) |> collect
end

function aquariumAfter(days, aquarium)
  if days == 0
    return aquarium
  end

  return aquariumAfter(days - 1, nextAquarium(aquarium))
end

function main()
  println(aquariumAfter(80, parseInput()) |> length)
end

end # module

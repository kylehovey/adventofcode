module Day6

using Revise
using Memoize

@memoize function feesh()
  split(readline("./input.txt"), ",") .|> x -> parse(Int, x)
end

@memoize function fishCount()
  0:8 .|> x -> count(f -> f == x, feesh())
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

@memoize function fish(counter, daysLeft)
  if daysLeft == 0
    return 1
  elseif counter == 0
    return fish(8, daysLeft - 1) + fish(6, daysLeft - 1)
  else
    return fish(counter - 1, daysLeft - 1)
  end
end

function main()
  println(aquariumAfter(80, fishCount()) |> sum)
  println(sum(feesh() .|> counter -> fish(counter, 80)))
  println(aquariumAfter(256, fishCount()) |> sum)
  println(sum(feesh() .|> counter -> fish(counter, 256)))
end

end # module

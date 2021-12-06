using Memoize

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
  aquarium = split(readline("./input.txt"), ",") .|> x -> parse(Int, x)
  println(sum(aquarium .|> counter -> fish(counter, 256)))
end

module Day11

using Revise

function parseInput()
  lines = readlines("./input.txt") .|>
    line -> split(line, "") .|>
    char -> parse(Int, char)

  A = hcat(lines...)'
  m, n = size(A)

  [
    zeros(Int, (1, n + 2));
    zeros(Int, (m, 1)) A zeros(Int, (m, 1));
    zeros(Int, (1, n + 2));
  ]
end

function nextState(octopi)
  m, n = size(octopi)
  next = copy(octopi)
  next[2:(m-1), 2:(n-1)] .+= 1
  flashed = zeros(Int, (m, n))

  function canFlash(next, flashed)
    next .* (1 .- flashed)
  end

  function flashersLeft(next, flashed)
    A = canFlash(next, flashed)
    length(A[A.>9]) > 0
  end

  while flashersLeft(next, flashed)
    for flasher ∈ findall(>(9), canFlash(next, flashed))
      x = flasher[1]
      y = flasher[2]

      if flashed[x, y] == 0
        next[(x-1):(x+1), (y-1):(y+1)] .+= [
          1 1 1;
          1 0 1;
          1 1 1
        ]
        flashed[x, y] = 1
      end

      next[flashed .== 1] .= 0
    end

    next[1:1, 1:m] .= 0
    next[1:n, 1:1] .= 0
    next[1:m, m:n] .= 0
    next[m, 1:n] .= 0

    next = copy(next)
  end

  next, length(flashed[flashed .== 1])
end

function flashCountOf(octopi, t = 0, flashes = 0)
  if t == 0
    return flashes
  end

  next, flashCount = nextState(octopi)

  return flashCountOf(next, t - 1, flashes + flashCount)
end

function stepsToSync(octopi, t = 0)
  if all(==(0), octopi)
    return t
  end
  
  next, _ = nextState(octopi)

  return stepsToSync(next, t + 1)
end

function partOne()
  flashCountOf(parseInput(), 100)
end

function partTwo()
  stepsToSync(parseInput())
end

end # module

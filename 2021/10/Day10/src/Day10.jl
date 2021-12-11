module Day10

using Revise
using DataStructures

function parseInput()
  readlines("./input.txt")
end

function closingFor(c)
  if c == '('
    return ')'
  elseif c == '['
    return ']'
  elseif c == '{'
    return '}'
  else c == '<'
    return '>'
  end
end

function corruptionOf(line)
  contexts = Stack{Char}()

  for c in line
    if c ∈ ('(', '[', '{', '<')
      push!(contexts, c)
    elseif !isempty(contexts)
      context = pop!(contexts)

      if c != closingFor(context)
        return c
      end
    end
  end

  if !isempty(contexts)
    remaining = ""

    for context ∈ contexts
      remaining *= closingFor(context)
    end

    return remaining
  else
    return ""
  end
end

function partOne()
  function scoreFor(c)
    if c == ')'
      return 3
    elseif c == ']'
      return 57
    elseif c == '}';
      return 1197
    else
      return 25137
    end
  end

  filter(
    x -> typeof(x) === Char,
    parseInput() .|> corruptionOf,
  ) .|> scoreFor |> sum
end

function partTwo()
  function charScore(c)
    if c == ')'
      return 1
    elseif c == ']'
      return 2
    elseif c == '}';
      return 3
    else
      return 4
    end
  end

  function scoreFor(completion)
    score = 0

    for c in completion
      score *= 5
      score += charScore(c)
    end

    return score
  end

  scores = filter(
    x -> typeof(x) === String,
    parseInput() .|> corruptionOf,
  ) .|> scoreFor |> sort

  scores[length(scores)/2 |> ceil |> Int]
end

end # module

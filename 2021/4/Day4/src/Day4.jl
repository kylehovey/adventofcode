module Day4

using Revise
using LinearAlgebra

struct BoardState
  board::Matrix{Int}
  picked::Matrix{Int}
  lastPicked::Int
end

seed = [ones(Int, (5,1)) zeros(Int, (5,4))]'
rotate = [
  0 0 0 0 1;
  1 0 0 0 0;
  0 1 0 0 0;
  0 0 1 0 0;
  0 0 0 1 0;
]

ident = I(5) + zeros(Int, (5, 5))
digSieves = [ident, reverse(ident, dims=1)]
rowSieves = map(rot -> (rotate ^ rot) * seed, 0:4)
colSieves = transpose.(rowSieves)
sieves = [digSieves; rowSieves; colSieves]

function parseInput()
  input = readlines("./input.txt")
  picks = map(x -> parse(Int, x), split(input[1], ','))
  boards = input[2:end] |>
    data -> filter(row -> length(row) > 0, data)  |>
    data -> Iterators.partition(data, 5) |>
    collect |>
    data -> map(
      board -> map(
        row -> map(
          num -> parse(Int, num),
          split(row)
        ),
        board
      ),
      data
    ) |>
    data -> map(board -> hcat(board...), data) |>
    data -> map(board -> BoardState(board, zeros(Int, (5, 5)), -1), data)

  boards, picks
end

function hasWon(state::BoardState)
  linesWon = sieves |>
    data -> map(sieve -> sieve .* state.picked, data) |>
    data -> filter(ofLine -> sum(ofLine) == 5, data)

  length(linesWon) > 0
end

function measureOf(state::BoardState)
  state.lastPicked * sum((ones(Int, (5, 5)) - state.picked) .* state.board)
end

function nextBoard(state::BoardState, pick::Int)
  nextPicked = map(x -> x == pick ? 1 : 0, state.board) + state.picked

  BoardState(state.board, nextPicked, pick)
end

function findMeasureOfFirstWinner(states::Array{BoardState}, (pick, remaining...))
  nextStates = map(state -> nextBoard(state, pick), states)
  winners = filter(hasWon, nextStates)

  if length(winners) > 0
    return measureOf(winners[1])
  end

  return findMeasureOfFirstWinner(nextStates, remaining)
end

function findMeasureOfLastWinner(states::Array{BoardState}, (pick, remaining...), lastWinner = Nothing)
  if length(states)  == 0
    return measureOf(lastWinner)
  end

  nextStates = map(state -> nextBoard(state, pick), states)
  winners = filter(hasWon, nextStates)
  losers = filter(!hasWon, nextStates)

  if length(winners) > 0
    return findMeasureOfLastWinner(losers, remaining, winners[1])
  end

  return findMeasureOfLastWinner(losers, remaining, lastWinner)
end

function main()
  states, picks = parseInput()

  return findMeasureOfFirstWinner(states, picks), findMeasureOfLastWinner(states, picks)
end

end # module

const { chunk, range } = require("lodash");
const crabs = require('./input.js')

function selection(arr, k = Math.round(arr.length / 2) - 1) {
  // Use simple algorithm for small length
  if (arr.length < 100) {
    const copy = [...arr];
    copy.sort((a, b) => a - b);

    return copy[k];
  }

  // Find a good pivot
  const pivot = selection(
    chunk(arr, 5)
      .map(slice => {
        slice.sort((a, b) => a - b);
        return slice[2];
      })
  );

  // Partition arrays
  const [ less, equal, greater ] = [
    x => x < pivot,
    x => x === pivot,
    x => x > pivot
  ].map(compare => arr.filter(compare));

  // Determine partitions
  const [ lower, upper, max ] = [
    less.length,
    less.length + equal.length,
    less.length + equal.length + greater.length
  ];

  // Prune and continue
  if (k <= lower) {
    return selection(less, k);
  } else if (k > lower && k <= upper) {
    return pivot;
  } else if (k > upper) {
    return selection(greater, k - upper);
  }
}

function firstMetric(lats, choice) {
  return lats
    .map(lat => Math.abs(choice - lat))
    .reduce((sum, val) => sum + val);
}

function secondMetric(lats, choice) {
  return lats
    .map(lat => {
      const x = Math.abs(choice - lat);

      return x * (x + 1) / 2;
    })
    .reduce((sum, val) => sum + val);
}

function pickMainPipeline(lats) {
  return selection(lats);
}

function bruteForcePipeline(lats, metric) {
  const possible = [
    Math.min(...lats),
    Math.max(...lats) + 1
  ];

  return range(...possible)
    .map(choice => ({
      choice,
      cost : metric(lats, choice)
    }))
    .reduce((best, inst) => {
      return (inst.cost < best.cost) ? inst : best;
    });
}

const choice = pickMainPipeline(crabs);

console.log("Brute force part one:");
console.log(bruteForcePipeline(crabs, firstMetric));

console.log("Brute force part two:");
console.log(bruteForcePipeline(crabs, secondMetric));

console.log("Linear algo part one:");
console.log({
  choice,
  cost : firstMetric(crabs, choice),
});

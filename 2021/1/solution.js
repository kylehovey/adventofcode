const data = require('./input.json');

const numIncreased = (xs) => xs.reduce(({ last, count }, next) => ({
  count: next > last ? count + 1 : count,
  last: next,
}), {
  last: Infinity,
  count: 0,
}).count;

const convolve = (xs, kernel) => {
  const outputSize = 1 + xs.length - kernel.length;

  return Array(outputSize).fill().map(
    (_, index) => kernel.reduce(
      (acc, mult, step) => (
        acc + mult * xs[index + step]
      ),
      0,
    ),
  );
};

// Part one
console.log(numIncreased(data));

// Part two
console.log(numIncreased(convolve(data, [1,1,1])));

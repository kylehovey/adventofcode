const data = require('./input.json');

const { length } = data;
const [{ length: width }] = data;

const toArray = str => str.split('').map(x => parseInt(x, 10));
const sum = (A, B) => A.map((a, i) => a + B[i]);
const parsed = data.map(toArray);
const mostCommonOf = arr => arr.reduce(sum).map(x => x >= arr.length / 2 ? 1 : 0);
const leastCommonOf = arr => arr.reduce(sum).map(x => x < arr.length / 2 ? 1 : 0);
const gamma = parseInt(mostCommonOf(parsed).join(''), 2);
const epsilon = parseInt(leastCommonOf(parsed).join(''), 2);

const measure = (arr) => ({
  withMethod(method, bit = 0) {
    const criteria = method(arr);

    if (arr.length === 1) return arr[0];

    return measure(
      arr.filter(word => word[bit] === criteria[bit]),
    ).withMethod(method, bit + 1);
  },
});

const oxy = parseInt(measure(parsed).withMethod(mostCommonOf).join(''), 2);
const co2 = parseInt(measure(parsed).withMethod(leastCommonOf).join(''), 2);

console.log(gamma*epsilon);
console.log(oxy*co2);

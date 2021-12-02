const instructions = require('./input.json');

const horizontalPattern = /^(forward).+(\d+)/;
const verticalPattern = /^(up|down).+(\d+)/;

const serialize = (string) => {
  const [,command,amountString] = horizontalPattern.exec(string) || verticalPattern.exec(string);
  const amount = parseInt(amountString, 10);

  return {
    forward: [amount, 0],
    up: [0, -amount],
    down: [0, amount],
  }[command];
};

{
  // Part one
  const [ forward, depth ] = instructions
    .map(serialize)
    .reduce(([a, b], [A, B]) => [a + A, b + B], [0, 0]);

  console.log(forward * depth);
}

{
  // Part two
  const [ forward, depth ] = instructions
    .map(serialize)
    .reduce(([_forwardNet, _depthNet, _aimNet], [_forward, _dAim]) => [
      _forwardNet + _forward,
      _depthNet + _aimNet * _forward,
      _aimNet + _dAim,
    ], [0, 0, 0]);

  console.log(forward * depth);
}

const input = require("./input.json");
const smol = require("./smol.json");

const isSmall = (label) => label === label.toLocaleLowerCase();

const graphOf = (serialized) => serialized.reduce(
  (graph, edge) => (([A, B]) => ({
    ...graph,
    [A]: [...(A in graph ? graph[A] : []), B],
    [B]: [...(B in graph ? graph[B] : []), A],
  }))(edge.split("-")),
  {},
);

const allPaths = (graph, start, end, noGo, path=[start]) => (
  graph[start].reduce(
    (paths, next) => [
      ...paths,
      ...(
        next === end
          ? [[...path, end]]
          : noGo(path, next)
            ? []
            : allPaths(graph, next, end, noGo, [...path, next])
      ),
    ],
    [],
  )
);

const noGoOne = (path, next) => path.includes(next) && isSmall(next);
const noGoTwo = (path, next) => (
  (isSmall(next) && path.filter(name => name === next).length === 2) ||
  (isSmall(next) && path.includes(next) && (
    (smalls) => [...new Set(smalls)].length !== smalls.length
  )(path.filter(isSmall))) ||
  next === "start"
);

console.log(allPaths(graphOf(input), 'start', 'end', noGoOne).length);
console.log(allPaths(graphOf(input), 'start', 'end', noGoTwo).length);

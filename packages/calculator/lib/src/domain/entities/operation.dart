/// Calculator operations
enum Operation {
  add('+'),
  subtract('-'),
  multiply('*'),
  divide('/');

  const Operation(this.symbol);

  final String symbol;
}

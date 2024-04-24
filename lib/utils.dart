class Pair<T> {
  Pair({
    required this.obj,
    required this.index,
  });

  final T obj;
  final int index;
}

extension IndexList<T> on Iterable<T> {
  Iterable<Pair<T>> get indexed {
    int i = 0;
    return this.map((e) => Pair(obj: e, index: i++));
  }
}

import "package:meta/meta.dart";

@immutable
class Config {
  final int runs, size;

  const Config({@required this.runs, @required this.size})
      : assert(runs != null && runs > 0),
        assert(size != null && size >= 0);
}

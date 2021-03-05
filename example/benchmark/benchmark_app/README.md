# Fast Immutable Collections' Example

![GIF][gif]

> You might need to run it with `flutter run --no-sound-null-safety` since some of its dependencies haven't yet transitioned into NNBD.

The example project for the [`fast_immutable_collections_benchmarks`][fast_immutable_collections_benchmarks] package.

This app is meant to be played as a benchmark for the [`fast_immutable_collections`][fast_immutable_collections] package.

Use it preferably under Flutter's `release` mode in order to have the truest comparisons possible. Check out the `.vscode/launch.json` file for more, if you're using VS Code. You can also run under release mode through the terminal:

> Using <kbd>Ctrl</kbd> + <kbd>F5</kbd> in VS Code won't work if you're on the outer, global context of the project. You have to open the example project separatedly if you wish to use the shortcut correctly, with the `.vscode/launch.json` configuration file.

```cmd
flutter run -d <device_id> --release
```


[fast_immutable_collections]: https://github.com/marcglasberg/fast_immutable_collections
[fast_immutable_collections_benchmarks]: https://github.com/marcglasberg/fast_immutable_collections/tree/master/example/benchmark
[gif]: https://raw.githubusercontent.com/marcglasberg/fast_immutable_collections/master/assets/demo.gif

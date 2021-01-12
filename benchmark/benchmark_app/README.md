# Fast Immutable Collections' Example

![GIF][gif]

The example project for the [`fast_immutable_collections_benchmarks`][fast_immutable_collections_benchmarks] package.

This app is meant to be played as a benchmark for the [`fast_immutable_collections`][fast_immutable_collections] package.

Use it preferably under Flutter's `release` mode in order to have the truest comparisons possible. Check out the [`.vscode/launch.json`][vscode_launch] file for more, if you're using VS Code. You can also run under release mode through the terminal:

> Using <kbd>Ctrl</kbd> + <kbd>F5</kbd> in VS Code won't work if you're on the outer, global context of the project. You have to open the example project separatedly if you wish to use the shortcut correctly, with the `.vscode/launch.json` configuration file.

```cmd
flutter run -d <device_id> --release
```


[fast_immutable_collections]: ../../
[fast_immutable_collections_benchmarks]: ../
[gif]: ../assets/demo.gif
[vscode_launch]: .vscode/launch.json
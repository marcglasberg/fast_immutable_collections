#!/bin/bash

cd benchmark
flutter pub get

cd example
flutter pub get

cd ../..
dartanalyzer --fatal-infos --fatal-warnings .

exit 0
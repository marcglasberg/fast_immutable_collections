#!/bin/bash

cd benchmark || exit
flutter pub get

cd benchmark_app || exit
flutter pub get

cd ../..
dartanalyzer --fatal-infos --fatal-warnings .

exit 0

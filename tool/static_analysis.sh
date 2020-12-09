#!/bin/bash

cd benchmark || exit
flutter pub get

cd example || exit
flutter pub get

cd ../..
dartanalyzer --fatal-infos --fatal-warnings .

exit 0

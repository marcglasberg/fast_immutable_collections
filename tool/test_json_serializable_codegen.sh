#!/bin/bash

set -e

cd test/json_serializable_e2e_test

dart pub get
dart run build_runner build --delete-conflicting-outputs
dart test

cd ..

exit 0

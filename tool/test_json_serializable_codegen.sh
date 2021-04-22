#!/bin/bash

set -e;

cd json_serializable_e2e_test;

dart pub get;
dart run build_runner build --delete-conflicting-outputs;
dart test;

#!/bin/bash

set -euo pipefail

# Resolve the nested package before analyzing the entire checkout.
(cd json_serializable_e2e_test && dart pub get)

dart analyze --fatal-infos --fatal-warnings .

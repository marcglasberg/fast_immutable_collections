#!/bin/bash

set -euo pipefail

dart analyze --fatal-infos --fatal-warnings .

#!/bin/sh

export PATH="$PATH":"$HOME/.pub-cache/bin"

(pub global list | grep coverage) || {
  pub global activate coverage
}

pub global run coverage:collect_coverage \
    --port=8111 \
    --out=out/coverage/coverage.json \
    --wait-paused \
    --resume-isolates \
    &

dart \
    --disable-service-auth-codes \
    --enable-vm-service=8111 \
    --pause-isolates-on-exit  \
    test

pub global run coverage:format_coverage \
    --lcov \
    --in=out/coverage/coverage.json \
    --out=out/coverage/lcov.info \
    --packages=.packages \
    --report-on lib

exit 0

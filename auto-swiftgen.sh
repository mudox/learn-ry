#!/usr/bin/env bash
set -euo pipefail

fswatch --one-per-batch LearnRY | xargs -n 1 bash ./swiftgen.sh

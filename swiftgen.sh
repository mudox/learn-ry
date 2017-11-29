#!/usr/bin/env bash
set -euo pipefail

outputDir="LearnRY/SwiftGen"

# storyboards
swiftgen storyboards -t swift4 -o "${outputDir}/Storyboards.swift" LearnRY/**/*.storyboard
# assets
swiftgen xcassets -t swift4 -o "${outputDir}/Assets.swift" LearnRY/**/*.xcassets

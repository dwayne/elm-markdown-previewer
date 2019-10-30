#!/bin/sh

set -e

js="markdown-previewer.js"

elm make --debug --output=$js src/Main.elm

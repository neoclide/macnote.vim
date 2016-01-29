#!/usr/bin/env bash

marked=`dirname $PWD`/bin/marked
template=`dirname $PWD`/template/default.html
cat sample.md | $marked $template > sample.html
open sample.html

#!/bin/bash
rm *.beam
erlc corrector.erl expander.erl
escript shell.erl
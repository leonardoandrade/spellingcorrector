#!/bin/bash
rm *.beam
erlc corrector.erl expander.erl
escript corrector_test.erl
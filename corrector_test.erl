-module(corrector_test).

-import(corrector, [correct/1, init/1]).

test_valid_word() ->
	"before" = corrector:correct("before"),
	io:format("passed test_valid_word~n").

test_distance_1() ->
	"that" = corrector:correct("thxt"),
	io:format("passed test_distance_1~n").

test_distance_2() ->
	"little" = corrector:correct("lixxle"),
	io:format("passed test_distance_2~n").

main(_) ->
	corrector:init("word_frequency_100.txt"),
	test_valid_word(),
	test_distance_1(),
	test_distance_2(),
	erlang:halt().



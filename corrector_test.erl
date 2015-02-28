-module(corrector_test).
-import(corrector, [correct/1, init/1]).

test_distance_1() ->
	%"that" = corrector:correct("thxt").
	X = corrector:correct("thxt"),
	io:format("---> ~p~n",[X]).

test_distance_2() ->
	"little" = corrector:correct("lixxle").


main(_) ->
	corrector:init("word_frequency_100.txt"),
	test_distance_1(),
	test_distance_2(),
	erlang:halt().



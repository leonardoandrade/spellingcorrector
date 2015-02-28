-module(shell).

-import(corrector, [init/1, correct/1]).

-export([main/1]).


loop_input() ->
  Word = string:strip(io:get_line("> "),both,$.),
  WordTrimmed = re:replace(Word, "(^\\s+)|(\\s+$)", "", [global,{return,list}]),
  io:format("~p~n",[WordTrimmed]),
  corrector:correct(WordTrimmed),
  loop_input().

main(_) ->
  io:format("loading dictionary..."),
  corrector:init("word_frequency_30k.txt"),
  io:format("done~n"),
  loop_input(),
  erlang:halt().

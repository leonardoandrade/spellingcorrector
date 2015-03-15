-module(shell).

-import(corrector, [init/1, correct/1]).

-export([main/1]).


loop_input() ->
  Word = string:strip(io:get_line("> "),both,$.),
  WordTrimmed = re:replace(Word, "(^\\s+)|(\\s+$)", "", [global,{return,list}]),
  case length(WordTrimmed) =:= 0 of 
    true -> loop_input();
    false -> 
  

  CorrectedWord = corrector:correct(WordTrimmed),
  case (length(CorrectedWord) =:= 0) of 
    true -> 
      io:format("correction not found for ~p~n",[Word]);
    false ->
      case (CorrectedWord =:= WordTrimmed) of 
        true ->
          io:format("word '~p' is correct~n",[CorrectedWord]);
        false -> 
          io:format("did you mean ~p ?~n",[CorrectedWord])
      end
  end
end,
  loop_input().

main(_) ->
  io:format("loading dictionary..."),
  corrector:init("word_frequency_30k.txt"),
  io:format("done~n"),
  loop_input(),
  erlang:halt().

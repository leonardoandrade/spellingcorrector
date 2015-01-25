-module(corrector).

-import(expander, [expand/1]).

-export([corrector/0]).

line_token_to_tuple([_|[H2|[H3|[]]]]) ->
  {string:to_lower(H2), element(1,string:to_integer(re:replace(H3,"\n","",[{return,list}])))}.

%loads dictionary from file
load_file(Filename)  ->
  {ok, FD} = file:open(Filename, [read]),
  load_lines(FD).


load_lines(FD) ->
  case io:get_line(FD, "") of
    eof  -> [];
    Line -> [line_token_to_tuple(string:tokens(Line, "\t"))] ++ load_lines(FD)
  end.



find_most_common_aux(_, [], SolutionWord, _) ->
  SolutionWord;

find_most_common_aux(Dict, [H|T], SolutionWord, SolutionFreq) ->
  X = maps:get(H, Dict, -1),
  %io:format("X: ~p H: ~p~n",[H,X]),
  case  (X > SolutionFreq) of
    true -> find_most_common_aux(Dict, T, H, X);
    false -> find_most_common_aux(Dict, T, SolutionWord, SolutionFreq)
    end.


find_most_common(Dict, Words) ->
  find_most_common_aux(Dict, Words, "",0).

loop_correct(Dict) ->
    receive
      {correct, Word} ->
        PossibleWords = expander:expand(Word),
        X = "Did you mean '"++find_most_common(Dict,PossibleWords) ++ "' ?",
        io:format("~p~n",[X]),
        loop_correct(Dict)
    end.

corrector() ->
  Dict = maps:from_list(load_file("word_frequency_10K.txt")),
  loop_correct(Dict).

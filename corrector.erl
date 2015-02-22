-module(corrector).

-import(expander, [expand/1]).

-export([correct/1, init/1, loop_correct/1]).


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
      {correct, Sender, Word} ->
        PossibleWords = expander:expand(Word),
        Sender ! {found, find_most_common(Dict,PossibleWords)},
        loop_correct(Dict)
    end.

init(DictionaryFile) ->
  Dict = maps:from_list(load_file(DictionaryFile)),
  Pid = spawn(?MODULE, loop_correct, [Dict]),
  register(server, Pid).


correct(Word) ->
  io:format("~p~n",[self()]),
  whereis(server) ! {correct, self(), Word},
  receive
    {found, CorrectedWord} ->
      X = "Did you mean '"++ CorrectedWord ++ "' ?",
      io:format("~p~n",[X])
  end.

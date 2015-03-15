-module(corrector).

-import(expander, [expand/1]).

-export([correct/1, init/1, loop_correct/1]).

-define(MIN_SIZE_TO_DOUBLE_EXPAND, 6).


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
        case maps:get(Word, Dict, -1) of 
          X when X =/= -1  -> 
           Sender ! {found, Word},
            loop_correct(Dict);
          _ ->  
            PossibleWords = expander:expand(Word, expand_once), % get all the possible variations from expander
            CorrectedWord = find_most_common(Dict,PossibleWords), % find most common word as a solution
          
            % only double-expand short words, because performance
            case ((length(CorrectedWord) == 0) and (length(Word) =< ?MIN_SIZE_TO_DOUBLE_EXPAND)) of 
              true ->
                PossibleWords2 = expander:expand(Word, expand_twice),
                CorrectedWord2 = find_most_common(Dict,PossibleWords2),
                Sender ! {found, CorrectedWord2};
              false ->
                Sender ! {found, CorrectedWord} 
              end,
            loop_correct(Dict)
          end
      end.

%initialize corrector with dictionary
init(DictionaryFile) ->
  Dict = maps:from_list(load_file(DictionaryFile)),
  Pid = spawn(?MODULE, loop_correct, [Dict]),
  register(spelling_corrector_server, Pid).

correct([]) -> [];

%correct a word
correct(Word) ->
  whereis(spelling_corrector_server) ! {correct, self(), Word},
  receive    
    {found, CorrectedWord} ->
      CorrectedWord
  end.





-module(expander).

-export([expand/1]).

alphabet_en() ->
  "abcdefghijklmnopqrstuvxz".

alphabet_de() ->
  "abcdefghijklmnopqrstuvxzäöüß".

%remove letters from word
remove_letters(L, _, []) ->
  L;
remove_letters(L, H1, [H2|T]) ->
  remove_letters(L++[H1++T], H1++[H2], T).

remove_letters(L) ->
  remove_letters([],[],L).

%add letters
add_letters(L, _, []) ->
  L;
add_letters(L, H1, [H2|T]) ->
  M = [H1++[X]++[H2]++T || X <- alphabet_de()],
  add_letters(L++M, H1++[H2], T).

add_letters(L) ->
  add_letters([],[],L).

%replace letters
replace_letters(Word) ->
  D = remove_letters(Word),
  lists:append([add_letters(X) || X <- D]).

%just for printing
print_list([]) -> true;
print_list([H|T]) -> io:format("--> ~p~n", [H]), print_list(T).

expand(Word) ->
  L = remove_letters(string:to_lower(Word)) ++
  add_letters(string:to_lower(Word)) ++
  replace_letters(string:to_lower(Word)),
  %io:format("length: ~p~n",[length(L)]),
  %print_list(L),
  L.

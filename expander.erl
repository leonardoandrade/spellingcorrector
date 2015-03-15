-module(expander).

-export([expand/1, expand/2]).

alphabet_en() ->
  "abcdefghijklmnopqrstuvxz".

%alphabet_de() ->
%  "abcdefghijklmnopqrstuvxzäöüß".

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
  M = [H1++[X]++[H2]++T || X <- alphabet_en()],
  add_letters(L++M, H1++[H2], T).

add_letters(L) ->
  add_letters([],[],L).

%replace letters
replace_letters(Word) ->
  D = remove_letters(Word),
  lists:append([add_letters(X) || X <- D]).

%just for printing
%print_list([]) -> true;
%print_list([H|T]) -> io:format("--> ~p~n", [H]), print_list(T).

expand(Word) ->
  expand(Word, expand_once).

expand(Word, expand_once) ->
  L = remove_letters(string:to_lower(Word)) ++
  add_letters(string:to_lower(Word)) ++
  replace_letters(string:to_lower(Word)),
  sets:to_list(sets:from_list(L));

expand(Word, expand_twice) ->
  io:format("performing double expansion, this may take a while ~n"),

  L1 = expand(Word, expand_once),
  io:format("list size after one expansion: ~p~n",[length(L1)]),
  
  L2 = lists:flatmap(fun(X) -> expand(X) end,L1),
  io:format("list size after second expansion (with duplicates): ~p~n",[length(L2)]),

  L3 = sets:to_list(sets:from_list(L2)),
  io:format("list size after second expansion (without duplicates): ~p~n",[length(L3)]),
  L3.


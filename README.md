# Spellingcorrector
Spelling corrector in Erlang

Based on the  (Norvig article)[http://norvig.com/spell-correct.html]

Word requency list taken from wiktionary.org (top 30K)
http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists

##Usage

```
$> erl
1>  c(corrector).          
{ok,corrector}          
2> corrector: init("word_frequency_30k.txt").
true
3>  corrector: correct("banxna").             
"Did you mean 'banana' ?"
ok
```


# Spellingcorrector
Spelling corrector in Erlang

Based on the [Norvig article](http://norvig.com/spell-correct.html)

Word requency list taken from [wiktionary.org](http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists)

##Usage

```bash
$> erl
1>  c(corrector).          
{ok,corrector}          
2> corrector: init("word_frequency_30k.txt").
true
3>  corrector: correct("banxna").             
"Did you mean 'banana' ?"
ok
```


# Spellingcorrector
Spelling corrector in Erlang

Based on the [Norvig article](http://norvig.com/spell-correct.html)

Word requency list taken from [wiktionary.org](http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists)

##Usage

```bash
$> ./run.sh
➜  spellingcorrector git:(master) ✗ ./run.sh
loading dictionary...done
> banxana
did you mean "banana" ?
> banana
word '"banana"' is correct
```

##TODO
 * optimize second expansion
 * implement character replacement based on soundex


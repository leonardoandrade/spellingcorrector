# Spellingcorrector
Spelling corrector in Erlang. Based on the [Norvig article](http://norvig.com/spell-correct.html).
Uses detached Erlang process for correction. Requests via message.
Word frequency list taken from [wiktionary.org](http://en.wiktionary.org/wiki/Wiktionary:Frequency_lists)

##Usage

![usage](usage.png)

##TODO
 * space-optimize second expansion
 * implement character replacement based on [soundex](http://http://en.wikipedia.org/wiki/Soundex) and QUERY keyboard key distance

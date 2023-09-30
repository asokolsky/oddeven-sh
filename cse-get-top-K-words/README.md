# Get top K words

Given a text file containing English words, return the top K most frequent
words. You need to convert all the words to lowercase and ignore the stop words
(provided in another text file).

Your script should take 2 arguments:

* the text file containing english words
* k

Example:

sample.txt:
```
The weather is sunny in SC. The weather is cloudy. the weather
```

stopwords:
```
foo
bar
```
Expected:

```
get_top_words.sh sample.txt 2
weather
cloudy
```

Note: If the top-k words have same frequency, then present them in
alphabetical order.

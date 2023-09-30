#/usr/bin/bash

# tokenize the input, one token per line
cat sample.txt| tr -d ',.;:!?"\r'| tr '[:space:]' '\n'|grep -v '^\s*$'|tr '[:upper:]' '[:lower:]'| sort | uniq -c| sort -bnr> /tmp/input-sorted-unique-counts
#tr "[:upper:]" "[:lower:]" < "$file_name" | grep -oE '\w+' | grep -vwFf stopwords | sort | uniq -c | sort -bnr > /tmp/input-sorted-unique-counts

# tr -d ',.;:!?"\r' - discard these chars
# tr '[:space:]' '\n' - replace these chars with \n
# grep -v '^\s*$' - drop empty lines
# tr '[:upper:]' '[:lower:]' - convert to lower case
# sort - sort the lines
# uniq -c - print count uniques
# sort -bnr - sorts in numeric reverse order while ignoring whitespace

# /tmp/input-sorted-unique-counts looks like:
#     17 the
#      8 your
#      8 you
#      7 will
#      7 in
#      6 weather

k=2

# https://www.xmodulo.com/key-value-dictionary-bash.html
declare -A occurences
# Set space as the delimiter
IFS=' '

i=0 # running number of words added
n_prev=0 # occurances of the last word added
while read line; do
    # Read the split words into an array based on space delimiter
    read -ra val_word <<< $line
    n="${val_word[0]}"
    word="${val_word[1]}"
    if grep -q -w $word ./stopwords ; then
        #echo "stopword: ${word}"
        :
    else
        #echo "adding ${word}"
        occurences["${word}"]="${n}"
        ((i++))
        #echo "i=${i} n_prev=${n_prev} n=${n} word=${word}"
        if [[ "$n" == "$n_prev" ]] ; then
            #echo "keep adding - we need the last with this occurance"
            :
        elif [[ "$i" > "$k" ]] ; then
            #echo "bailing"
            break
        fi
        n_prev="${n}"
    fi
done < /tmp/input-sorted-unique-counts

# by now $n_prev is lowest occurance we are interested in

# those with the same occurance
words=()

i=0 # running number
for word in "${!occurences[@]}"; do
    n=${occurences[$word]}
    #echo "== $word $n"
    if [[ "$n" > "$n_prev" ]] ; then
        echo $word
        ((i++))
    else
        #echo "maybe $word"
        words+=($word)
    fi
done

printed=$i

# https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
#echo ${words[*]}
IFS=$'\n' words=($(sort <<<"${words[*]}"))
unset IFS
#echo ${words[*]}

for i in "${!words[@]}"; do
    word=${words[$i]}
    #echo "== ${word}"
    #echo "printed=$printed k=$k"
    if [[ "$printed" < "$k" ]] ; then
        echo $word
        ((printed++))
    else
        break
    fi
done

#!/bin/bash
#
# get_top_words.ssh - Given a text file containing English words, return the top K most frequent words. You # need to convert all the words to lowercase and ignore the stop words (provided in another text file)
#
# input: text file containing english words and k
# output: a list of most occuring words in descending order and then alphabetically
#
# Sara Soldano, 1811836, ssoldano@ucsc.edu

# check to see if there is at least two arguments 
if [ "$#" -ne  "2" ] ; then
    echo "Error: needs two arguments"
    exit 1
fi

# variables for aruments 
file_name=$1
k=$2
stopwords=$(cat "stopwords")



#cat "$file_name" | tr [:upper:] [:lower:]
# turns the file into lower case | then creates a list of the words in the sentence | gets rid of the stop words | sorts the words in numerical and then alphabetically 
tr "[:upper:]" "[:lower:]" < "$file_name" | grep -oE '\w+' | grep -vwFf stopwords | sort | uniq -c | sort -k1,1rn | awk '{print $2}' | head -n $k # finally print only k amount of words

# steps:
# build a pipeline:
#  read content of the file
#  convert to lower case
# create dictionary of words and find word occurs most often
# ignore words from stopwords
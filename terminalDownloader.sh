#!/bin/bash

userAgent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36"

# Base URL for the files
baseUrl="https://wallpapercave.com"
# URL from which data is to be extracted
url="https://wallpapercave.com/dark-knight-hd-wallpaper"
# Project Name
project="DarkKnightDownloader"
# Folder into which files are downloaded
downloadsFolder="downloads"

# Most Important
# Regex to get your data
customRegex='img data-url="\K([^ "]*)'

# Flag to give hether to store webpage and data into files
storeFiles=true

# Web Page File Name
webPageFile="index.html"

# Regex Matchings File
customRegexFile="customRegex.txt"

# Removing any existing folder with $project
rm -rf "$project" && echo "Removed any existing directory with the name : $project"

# Make project directory
mkdir "$project" && cd "$project" && echo "Made new directory $project"

# Make downloads directory
mkdir "$downloadsFolder" && echo "Made downloads Folder $downloadsFolder"

# Get HTML Content
htmlContent=$(wget -U "$userAgent" "$url" -O -) 

echo "Retrieved the WebPage"


# Storing Web Page
if $storeFiles
then
  echo $htmlContent > "$webPageFile"
  echo "Stored Web Page to $webPageFile"	
fi

# Matching Patterns using grep
reqPatterns=$(echo $htmlContent | grep -Po "$customRegex")

echo "Applied custom Regex"

# Storing the Matchings
if $storeFiles
then
  echo $reqPatterns > "$customRegexFile"
  echo "Stored Regex Results to $customRegexFile"    
fi

cd $downloadsFolder


# Storing the files in download directory
while IFS= read -r -d $' ' word
do
  src="$baseUrl/wp/$word.jpg"
  # echo $src
  # echo $word	
  wget -U "$userAgent" $src
  echo "Downloaded from $src"
done < <(echo $reqPatterns)


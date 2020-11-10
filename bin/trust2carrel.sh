#!/usr/bin/env bash

# cord2carrel.sh - given the CORD data set, create "study carrel plus"

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame and distributed under a GNU Public License

# April  3, 2020 - first investigations
# May   15, 2020 - added JSON to txt functionality 
# May   31, 2020 - sent report to STDOUT, thus making the simple report visible 
# July   4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff


# enhance environment
#PERL_HOME='/export/perl/bin'
#JAVA_HOME='/export/java/bin'
PYTHON_HOME='/data-disk/python/bin'
#PATH=$PYTHON_HOME:$PERL_HOME:$JAVA_HOME:$PATH
PATH=$PYTHON_HOME:$PATH
export PATH

# configure
CARRELS="$READERTRUST_HOME/carrels"
CORPUS="./etc/reader.txt"
DB='./etc/reader.db'
REPORT='./etc/report.txt'
METADATA='./metadata.tsv'

# require
CARREL2ZIP='carrel2zip.pl'
COLLECTION2BOOKS='collection2books.sh'
DB2REPORT='db2report.sh'
INITIALIZECARREL='initialize-carrel.sh'
MAKEPAGES='make-pages.sh'
MAP='map.sh'
METADATA2SQL='metadata2sql.py'
REDUCE='reduce.sh'
METADATA2SQL='metadata2sql.py'

# get the name of newly created directory
NAME=$( pwd )
NAME=$( basename $NAME )
echo "Carrel name: $NAME" >&2

# create a study carrel
echo "Creating study carrel named $NAME" >&2
$INITIALIZECARREL $NAME

# create a collection
echo "Downloading collection" >&2
$COLLECTION2BOOKS $METADATA

# update database with metadata
echo "Updating database with metadata" >&2
$METADATA2SQL $METADATA       > ./tmp/bibliographics.sql
echo "BEGIN TRANSACTION;"     > ./tmp/update-bibliographics.sql
cat ./tmp/bibliographics.sql >> ./tmp/update-bibliographics.sql
echo "END TRANSACTION;"      >> ./tmp/update-bibliographics.sql
cat ./tmp/update-bibliographics.sql | sqlite3 $DB


# build the carrel; the magic happens here
echo "Building study carrel named $NAME" >&2

# start tika
java -jar /data-disk/lib/tika-server.jar &
PID=$!
sleep 10

# extract parts-of-speech, named entities, etc
$MAP $NAME
kill $PID

# build the database
$REDUCE $NAME

# build ./etc/reader.txt; a plain text version of the whole thing
echo "Building ./etc/reader.txt" >&2
rm -rf $CORPUS >&2
find "./txt" -name '*.txt' -exec cat {} >> "$CORPUS" \;
tr '[:upper:]' '[:lower:]' < "$CORPUS" > ./tmp/corpus.001
tr '[:digit:]' ' ' < ./tmp/corpus.001 > ./tmp/corpus.002
tr '\n' ' ' < ./tmp/corpus.002 > ./tmp/corpus.003
tr -s ' ' < ./tmp/corpus.003 > "$CORPUS"

# output a report against the database
$DB2REPORT $NAME > "$CARRELS/$NAME/$REPORT"
cat "$CARRELS/$NAME/$REPORT"

# create about file
$MAKEPAGES $NAME

# zip it up
echo "Zipping study carrel" >&2
#rm -rf ./tmp
#cp "$LOG/$NAME.log" "$NAME/log" 
$CARREL2ZIP $NAME
echo "" >&2

# make zip file accessible
cp "./etc/reader.zip" "./study-carrel.zip"

# done
exit

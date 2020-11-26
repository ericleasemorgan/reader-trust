#!/usr/bin/env bash

# htid2pdf.sh - given a key, secret, HathiTrust identifier, and size, build a PDF file

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 16, 2019 - first documentation
# July     11, 2019 - figured out how to parallelize the process; substantial speed increase
# July     14, 2019 - relaxing with a certain type of creativity
# July      4, 2020 - initializing reader-trust; jevggra va n svg bs perngvir ybaryvarff
# November 26, 2020 - changed output to jpg, and this was a surprise; on Thanksgiving in Lancaster during a pandemic


# configure
HARVEST='harvest-pdf.sh'
PAGES='./tmp/pages'
CACHE='./cache'

# sanity check
if [[ -z $1 || -z $2 ]]; then
	echo "Usage: $0 <HathiTrust identifier> <size>" >&2
	exit
fi

# more sanity checks
if [[ -z $HTKEY ]];    then echo "Error: The environment variable named HTKEY is not defined. Call Eric."; exit; fi
if [[ -z $HTSECRET ]]; then echo "Error: The environment variable named HTSECRET is not defined. Call Eric."; exit; fi

# get input
HTID=$1
SIZE=$2

# make sane
mkdir -p $PAGES
mkdir -p $CACHE
rm -rf $PAGES/*.jpg

# harvest each page
seq 1 $SIZE | parallel $HARVEST $HTID {}
wait

# build pdf and done
OUTPUT=$( echo $HTID | sed "s/\//-/g" )
/usr/bin/convert "${PAGES}/*.jpg" "${CACHE}/${OUTPUT}.pdf"
exit


#!/usr/bin/env bash

# queue2carrel.sh - submit queued work

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame and distributed under a GNU Public License

# November 29, 2020 - first cut; during Thanksgiving vacation in Lancaster in a pandemic


# configure
BACKLOG='/ocean/projects/cis210016p/shared/reader-compute/reader-trust/queue/backlog'
TRUST2CARREL='trust2carrel.sh'
CARRELS="$READERTRUST_HOME/carrels"

# get the input
if [[ -z $1 ]]; then
	echo "Usage: $0 <file>" >&2
	exit
fi
TSV=$1

# initialize and process the input
IFS=$'\t'
cat $TSV | while read TYPE SHORTNAME DATE TIME EMAIL CONTENT; do

	# debug
	echo "       to do: $TSV"       >&2
	echo "        type: $TYPE"      >&2
	echo "  short name: $SHORTNAME" >&2
	echo "        date: $DATE"      >&2
	echo "        time: $TIME"      >&2
	echo "       email: $EMAIL"     >&2
	echo "     content: $CONTENT"   >&2
	echo                            >&2
		
	# conditionally, create the carrel's directory
	if [[ -d "$CARRELS/$SHORTNAME" ]]; then
		echo "Carrel ($SHORTNAME) exists. Exiting." >&2
		exit
	else
		mkdir  "$CARRELS/$SHORTNAME"
	fi

	# for reasons of provenance, copy the queue file to the carrel
	cp $TSV "$CARRELS/$SHORTNAME/provenance.tsv"

	# check for valid/known processes; gutenberg
	if [[ $TYPE = "trust" ]]; then
			
		# make sane and do the work
		echo "Making sane and doing the work ($TRUST2CARREL)" >&2
		cd "$CARRELS/$SHORTNAME"
		mv $BACKLOG/$CONTENT ./metadata.tsv
		$TRUST2CARREL ./metadata.tsv 1>standard-output.txt 2>standard-error.txt &
		
	# unknown process
	else 

		echo "Error: Unknown type ($TYPE). Call Eric.\n" >&2
	
	fi

# fini
done
exit




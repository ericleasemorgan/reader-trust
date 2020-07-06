#!/usr/bin/env bash

# make-carrel.sh - given the name of a desired study carrel, make it

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# July 4, 2020 - va n svg bs ybaryl perngvivgl


# configure
TEMPLATE="$READERTRUST_HOME/etc/template.slurm"
CARRELS="$READERTRUST_HOME/carrels"
SLURM='./make-carrel.slurm'

# check for input
if [[ -z $1 ]]; then
	echo "Usage $0 <name>" >&2
	exit
fi

# get input
NAME=$1

# make sane
cd "$CARRELS/$NAME"

# create Slurm script
cat $TEMPLATE | sed "s/##NAME##/$NAME/" > $SLURM

# run the command and done
sbatch $SLURM
exit

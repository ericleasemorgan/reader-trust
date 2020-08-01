#!/bin/bash

# template.slurm - a SLURM template; a tautology 

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# June 2, 2020 - first documentation
# June 3, 2020 - added partition option


# sbatch configurations
#SBATCH -p big-cloud
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -t 48:0:00
#SBATCH -J ##NAME##
#SBATCH -o standard-output.txt
#SBATCH -e standard-error.txt
#SBATCH --mail-user=emorgan@nd.edu
#SBATCH --mail-type=ALL

# make sane
source '/home/centos/etc/reader-trust.cfg'
cd "$READERTRUST_HOME/carrels/##NAME##"

# assume this carrel is to be re-created; re-initialize
rm -rf adr                 &
rm -rf bib                 &
rm -rf cache               &
rm -rf css                 &
rm -rf ent                 &
rm -rf etc                 &
rm -rf figures             &
rm -rf htm                 &
rm -rf index.htm           &
rm -rf js                  &
rm -rf LICENSE             &
rm -rf MANIFEST.htm        &
rm -rf pos                 &
rm -rf README              &
rm -rf study-carrel.zip    &
rm -rf tsv                 &
rm -rf txt                 &
rm -rf urls                &
rm -rf wrd                 &
rm -rf tmp                 &
wait

# do the work
trust2carrel.sh

# done
exit

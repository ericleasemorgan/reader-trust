#!/usr/bin/env python

# metadata2sql.py - given a CSV file with a limited number of columns, output SQL

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame and distributed under a GNU Public License

# July 5, 2019 - first cut


# require
import sys
import pandas as pd
import os

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <tsv>\n" )
	quit()

# initialize
tsv = sys.argv[ 1 ]

# read the file and pivot it
metadata = pd.read_csv( tsv, sep='\t' )

# check for known columns; may add fields later
if   'author' in metadata : valid = True
elif 'title'  in metadata : valid = True
elif 'date'   in metadata : valid = True
else                      : valid = False

# check for validity
if valid == False :
	sys.stderr.write( "Invalid metadata file; need at least an author, title, or date column\n" )
	exit()

# pivot the table
metadata.set_index( 'htitem_id', inplace=True )

# process each row
for id, row in metadata.iterrows() :

	# initialize id
	print( "INSERT INTO bib ( 'id' ) VALUES ( '%s' );" % id )
	
	# author
	if 'author' in metadata :
		author = str( row[ 'author' ] )
		author = author.replace( "'", "''" )
		print( "UPDATE bib SET author = '%s' WHERE id is '%s';" % ( author, id ) )
	
	# title
	if 'title' in metadata :
		title = str( row[ 'title' ] )
		title = title.replace( "'", "''" )
		print( "UPDATE bib SET title = '%s' WHERE id is '%s';" % ( title, id ) )
	
	# date
	if 'date' in metadata :
		date = str( row[ 'date' ] )
		date = date.replace( "'", "''" )
		print( "UPDATE bib SET date = '%s' WHERE id is '%s';" % ( date, id ) )
	
	# delimit
	print()
	
# done
exit()

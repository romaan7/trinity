#!/usr/bin/env bash
#
# Copyright (C) Roman Shaikh <shaikhr@tcd.ie>
#
# This script identifies the type of hashes in file and adds them to new file.
# Hash identification is based on length and the identifier specifed, a better method needs to be implementd.

#set -x
FILENAME=$1

echo "Converting $FILENAME to unix format."
dos2unix $FILENAME
echo "--------------------------------------------------------------------------"
echo "Identifing hash types from file."
echo "--------------------------------------------------------------------------"
echo "Supported formats: DEScrypt,MD5Crypt,SHA256Crypt,SHA512Crypt,argon2,pbkdf2"
echo "--------------------------------------------------------------------------"

#Counters for keeping track of # of identified types
DES_COUNT=0
MD5_COUNT=0
ARGON2_COUNT=0
PBKDF_COUNT=0
SHA256_COUNT=0
SHA512_COUNT=0

while read line; do 
	CHAR_COUNT=$(echo $line | awk '{ print length($0); }')
	if [ $CHAR_COUNT -eq 13 ];then
	 #echo "$line seems like descrypt. Writing to $1.descrypt"
	 echo $line >> $1.descrypt
	 DES_COUNT=$((DES_COUNT + 1))
	elif [[ $line = \$\1* ]] ; then
	 #echo "$line seems like md5crypt. Writing to $1.md5crypt"
	 echo $line >> $1.md5crypt
	 MD5_COUNT=$((MD5_COUNT + 1))
	elif [[ $line = \$\a\r\g\o\n\2* ]] ; then
	 #echo "$line seems like argon2. Writing to $1.argon2"
	 echo $line >> $1.argon2
	 ARGON2_COUNT=$((ARGON2_COUNT + 1))
	elif [[ $line = \$\5* ]] ; then
	 #echo "$line seems like sha256crypt. Writing to $1.sha256crypt"
	 echo $line >> $1.sha256crypt
	 SHA256_COUNT=$((SHA256_COUNT + 1))
	elif [[ $line = \$\p\b\k\d\f\2* ]] ; then
	 #echo "$line seems like pbkdf2. Writing to $1.pbkdf2"
	 echo $line >> $1.pbkdf2
	 PBKDF_COUNT=$((PBKDF_COUNT + 1))
	elif [[ $line = \$\6* ]] ; then
	 #echo "$line seems like sha512crypt. Writing to $1.sha512crypt"
	 echo $line >> $1.sha512crypt
	 SHA512_COUNT=$((SHA512_COUNT + 1))
	else
	 echo "$line not identified"
	fi
done < $FILENAME
echo "--------------------------------------------------------------------------"
echo "Identified types
Descrypt=$DES_COUNT
MD5Crypt=$MD5_COUNT
ARGON2=$ARGON2_COUNT
PBKDF2=$PBKDF_COUNT
SHA256=$SHA256_COUNT
SHA512=$SHA512_COUNT
"
echo "Total hashes identified =  $(($DES_COUNT+$MD5_COUNT+$ARGON2_COUNT+$PBKDF_COUNT+$SHA256_COUNT+$SHA512_COUNT))"


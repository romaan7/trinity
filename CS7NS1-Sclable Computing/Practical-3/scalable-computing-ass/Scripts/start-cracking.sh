#!/usr/bin/env bash
#
# Copyright (C) Roman Shaikh <shaikhr@tcd.ie>
#
# For cracking in diffrent modes. 
# Argon2 is not supported by hashcat , try it with JTR

#set -x

function usage_info(){
	banner
	echo
	echo "USAGE: $0 <DICT-DIRECTORY> <POT-File> <HASH-FILE-DIRECTORY> "| grep --color 'USAGE'
	echo
	echo
	exit
}

clear
# supply usage if not called properly
if [ -z "$1" ] || [ "$1" == "-h" ] ||  [ "$1" == "--help" ] || [ $# -ne $ARGS ]; then
	usage_info
fi

DICT_DIR=$1
POT_FILE=$2
HASH_FILE_DIR=$3

HASHCAT_ROOT="/home/roman/tcd/assignment3/hashcat-4.2.1"
BRUTE_MASK=""

DES_HCODE=1500
MD5_HCODE=500
ARGON2_HCODE=
PBKDF_HCODE=10900
SHA256_HCODE=7400
SHA512_HCODE=1800

DES_SESSION_ID="des-session"
MD5_SESSION_ID="md5-session"
ARGON2_SESSION_ID="argon2-session"
PBKDF_SESSION_ID="pbkdf-session"
SHA256_SESSION_ID="sha256-session"
SHA512_SESSION_ID="sha512-session"

#Counters for keeping track of # of identified types

crack_aggrasive(){
echo "Starting to Crack."

nohup $HASHCAT_ROOT/hashcat64.bin --status --session=md5-session -o $HASH_HOME/md5.out -a 3 -m 500 -i --increment-min=6 $HASH_HOME/shaikhr.hashes.md5crypt ?a?a?a?a?a?a?a?a > md5.out 2>&1 &
for filename in $HASH_FILE_DIR/*.hashes.*; do
	if [[ $filename == *descrypt* ]];then
		nohup $HASHCAT_ROOT/hashcat64.bin --status --session=$DES_SESSION_ID -o $HASH_FILE_DIR/$DES_SESSION_ID.out -a 3 -m $DES_HCODE -i --increment-min=6 $filename ?a?a?a?a?a?a?a?a > $DES_SESSION_ID.out 2>&1 &
		echo "Process ID: `ps aux | grep $DES_SESSION_ID | awk '{print $2}'`"
	elif [[ $filename == *md5crypt* ]];then
		nohup $HASHCAT_ROOT/hashcat64.bin --status --session=$MD5_SESSION_ID -o $HASH_FILE_DIR/$MD5_SESSION_ID.out -a 3 -m $MD5_HCODE -i --increment-min=6 $filename ?a?a?a?a?a?a?a?a > $MD5_SESSION_ID.out 2>&1 &
		echo "Process ID: `ps aux | grep $MD5_SESSION_ID | awk '{print $2}'`"
	elif [[ $filename == *sha256* ]];then
		nohup $HASHCAT_ROOT/hashcat64.bin --status --session=$SHA256_SESSION_ID -o $HASH_FILE_DIR/$SHA256_SESSION_ID.out -a 3 -m $SHA256_HCODE -i --increment-min=6 $filename ?a?a?a?a?a?a?a?a > $SHA256_SESSION_ID.out 2>&1 &
		echo "Process ID: `ps aux | grep $SHA256_SESSION_ID | awk '{print $2}'`"
	elif [[ $filename == *pbkdf2* ]];then
		nohup $HASHCAT_ROOT/hashcat64.bin --status --session=$PBKDF_SESSION_ID -o $HASH_FILE_DIR/$PBKDF_SESSION_ID.out -a 3 -m $PBKDF_HCODE -i --increment-min=6 $filename ?a?a?a?a?a?a?a?a > $PBKDF_SESSION_ID.out 2>&1 &
		echo "Process ID: `ps aux | grep $PBKDF_SESSION_ID | awk '{print $2}'`"
	elif [[ $filename == *sha512* ]];then
		nohup $HASHCAT_ROOT/hashcat64.bin --status --session=$SHA512_SESSION_ID -o $HASH_FILE_DIR/$SHA512_SESSION_ID.out -a 3 -m $SHA512_HCODE -i --increment-min=6 $filename ?a?a?a?a?a?a?a?a > $SHA512_SESSION_ID.out 2>&1 &
		echo "Process ID: `ps aux | grep $SHA512_SESSION_ID | awk '{print $2}'`"
	fi
	
	echo "Running brute-force attack on: $filename"
done
}

crack_incremental(){

#incremental cracking 
}

crack_with_wordlist(){


}

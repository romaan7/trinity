import os,sys,argparse,base64,json
from Crypto.Cipher import AES
import secretsharing as sss
from hashlib import sha256

#EDITED BY AYUSH

# usage
def usage():
    print >>sys.stderr, "Usage: " + sys.argv[0] + " -i <input json file> -p <cracked pot file>" 
    sys.exit(1)

# getopt handling
argparser=argparse.ArgumentParser(description='Check cracked hashes against shares')
argparser.add_argument('-i','--input',     
                    dest='inputfile',
                    help='input file name')
argparser.add_argument('-p','--pot',     
                    dest='potfile',
                    help='pot file name')
args=argparser.parse_args()

# post opt checks
if args.inputfile is None:
    usage()

if args.potfile is None:
    usage()


if not os.path.isfile(args.inputfile) or not os.access(args.inputfile,os.R_OK):
    print "Can't read " + args.inputfile + " - exiting"
    sys.exit(2)
if not os.path.isfile(args.potfile) or not os.access(args.potfile,os.R_OK):
    print "Can't read " + args.potfile + " - exiting"
    sys.exit(2)


BLOCK_SIZE = 16
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * chr(BLOCK_SIZE - len(s) % BLOCK_SIZE)
unpad = lambda s: s[:-ord(s[len(s) - 1:])]


# Straight from https://github.com/sftcd/cs7ns1/blob/master/assignments/practical5/as5-makeinferno.py
def pxor(pwd,share):
    words=share.split("-")
    hexshare=words[1]
    slen=len(hexshare)
    hashpwd=sha256(pwd).hexdigest()
    hlen=len(hashpwd)
    outlen=0
    if slen<hlen:
        outlen=slen
        hashpwd=hashpwd[0:outlen]
    elif slen>hlen:
        outlen=slen
        hashpwd=hashpwd.zfill(outlen)
    else:
        outlen=hlen
    xorvalue=int(hexshare, 16) ^ int(hashpwd, 16) # convert to integers and xor
    paddedresult='{:x}'.format(xorvalue)          # convert back to hex
    paddedresult=paddedresult.zfill(outlen)       # pad left
    result=words[0]+"-"+paddedresult              # put index back
    return result


# Modified from https://www.quickprogrammingtips.com/python/aes-256-encryption-and-decryption-in-python.html
def decrypt(enc, password):
    password = password.zfill(32).decode('hex')
    enc = base64.b64decode(enc)
    iv = enc[:16]
    cipher = AES.new(password, AES.MODE_CBC, iv)
    return unpad(cipher.decrypt(enc[16:]))

#read pot file
pot_location = args.potfile
pot_file = open(pot_location,"r")
pot_lines=pot_file.read().splitlines()
pot_only_hashes = [i.split(':')[0] for i in pot_lines]
pot_only_passwords = [i.split(':')[1] for i in pot_lines] 

#1. Read in JSON
location = args.inputfile
f = open(location, "r")
data = json.load(f)
f.close()

ciphertext = data['ciphertext']
hashes = data['hashes']
shares = data['shares']


# 2. XOR the cracked passwords with their corresponding shares to create a list of
#    valid shares that could then be used to try to recover the key

def main():
	global hashes, shares
	xored = []
	for h, s in zip(hashes, shares):
		for number, pot_h in enumerate(pot_only_hashes):
			if h==pot_h:
				xored.append(str(pxor(pot_only_passwords[number], s)))

	print "\n[1/4] Read in {} chars of ciphertext and {} hashes, {} of which are cracked".format(len(ciphertext), len(hashes), len(xored))


	# 3. Use the XORed shares to generate the key
	secret = sss.SecretSharer.recover_secret(xored)
	print "[2/4] The cracked passwords generated this key: {}".format(secret)


	# 4. Use the generated key to attempt to decrypt the next level and do a quick check to see if we managed to decrypt it
	print "[3/4] Using the key to attempt to decrypt the next level..."
	d = decrypt(ciphertext, secret)
	success = False

	try:
	    j = json.loads(d)
	    cipher = len(j["ciphertext"])
	    hashes = len(j["hashes"])
	    print "      Looks like we unlocked the next level!"
	    print "      It has {} chars of ciphertext and {} hashes.".format(cipher, hashes)
	    print "      Here is the key that was used to unlock it: {}".format(secret)
	    success = True
	except Exception:
		print "      We most likely don't have enough passwords cracked because what was decrypted doesn't look like a JSON"
		print "      But still, have a look at the output file to be extra sure!"
		sys.exit(3)


	# 5. Save the result of the decryption to a file
	saveloc = location + ".unlocked.json"
	f = open(saveloc, "wb")
	f.write(d)
	f.close()
	print "[4/4] Saved what was decrypted to {}".format(saveloc)

	if success:	
		print "Congratulation!!!!"
		sys.exit(0)
	else:
		sys.exit(3)

if __name__=="__main__":
	main()
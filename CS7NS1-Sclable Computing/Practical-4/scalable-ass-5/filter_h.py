import os,sys,argparse,base64,json

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
    #print "Can't read " + args.inputfile + " - exiting"
    sys.exit(2)
if not os.path.isfile(args.potfile) or not os.access(args.potfile,os.R_OK):
   # print "Can't read " + args.potfile + " - exiting"
    sys.exit(2)


    
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

same=[]
for i,k in zip(pot_only_hashes,pot_only_passwords):
    for j in hashes:
        if i==j:
            if i+":"+k not in same:
                same.append(i+":"+k)
            
save_new_hashes = "level6.filter.hashses"
hs = open(save_new_hashes, "w")
for ln in same:
    hs.write("%s\n" % ln)


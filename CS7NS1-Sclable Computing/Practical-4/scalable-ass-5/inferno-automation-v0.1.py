import os, sys, argparse, base64, json, smtplib, time
from email.mime.multipart import MIMEMultipart 
from email.mime.text import MIMEText 
from email.mime.base import MIMEBase 
from email import encoders 
import secretsharing as sss
from Crypto.Cipher import AES
from hashlib import sha256


EMAIL="shaikhr@tcd.ie"
PASSWORD=""

# usage
def usage():
    print >> sys.stderr, "Usage: " + \
        sys.argv[0] + " -i <input json file> -p <cracked pot file>"
    sys.exit(1)


# getopt handling
argparser = argparse.ArgumentParser(
    description='Check cracked hashes against shares')
argparser.add_argument(
    '-i', '--input', dest='inputfile', help='input file name')
argparser.add_argument('-p', '--pot', dest='potfile', help='pot file name')
args = argparser.parse_args()

# post opt checks
if args.inputfile is None:
    usage()

if args.potfile is None:
    usage()

if not os.path.isfile(args.inputfile) or not os.access(args.inputfile,
                                                       os.R_OK):
    print "Can't read " + args.inputfile + " - exiting"
    sys.exit(2)
if not os.path.isfile(args.potfile) or not os.access(args.potfile, os.R_OK):
    print"Can't read " + args.potfile + " - exiting"
    sys.exit(2)

BLOCK_SIZE = 16
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * \
                     chr(BLOCK_SIZE - len(s) % BLOCK_SIZE)
unpad = lambda s: s[:-ord(s[len(s) - 1:])]


# Straight from
# https://github.com/sftcd/cs7ns1/blob/master/assignments/practical5/as5-makeinferno.py
def pxor(pwd, share):
    words = share.split("-")
    hexshare = words[1]
    slen = len(hexshare)
    hashpwd = sha256(pwd).hexdigest()
    hlen = len(hashpwd)
    outlen = 0
    if slen < hlen:
        outlen = slen
        hashpwd = hashpwd[0:outlen]
    elif slen > hlen:
        outlen = slen
        hashpwd = hashpwd.zfill(outlen)
    else:
        outlen = hlen
    xorvalue = int(hexshare, 16) ^ int(hashpwd,
                                       16)  # convert to integers and xor
    paddedresult = '{:x}'.format(xorvalue)  # convert back to hex
    paddedresult = paddedresult.zfill(outlen)  # pad left
    result = words[0] + "-" + paddedresult  # put index back
    return result


# Modified from
# https://www.quickprogrammingtips.com/python/aes-256-encryption-and-decryption-in-python.html
def decrypt(enc, password):
    password = password.zfill(32).decode('hex')
    enc = base64.b64decode(enc)
    iv = enc[:16]
    cipher = AES.new(password, AES.MODE_CBC, iv)
    return unpad(cipher.decrypt(enc[16:]))


# read pot file
def read_pot_file(potfile_loc):
    print "Reading POT File {}".format(potfile_loc)
    pot_location = potfile_loc
    pot_file = open(pot_location, "r")
    pot_lines = pot_file.read().splitlines()
    pot_only_hashes = [i.split(':')[0] for i in pot_lines]
    pot_only_passwords = [i.split(':')[1] for i in pot_lines]

    return pot_only_hashes, pot_only_passwords


def read_json_file(jsonfile_loc):
    print "Reading JSON File {}".format(jsonfile_loc)
    location = jsonfile_loc
    f = open(location, "r")
    data = json.load(f)
    f.close()
    ciphertext = data['ciphertext']
    hashes = data['hashes']
    shares = data['shares']

    return ciphertext, hashes, shares


def send_email(user, password, email_subject, email_body,email_attachment):
    # send an email for alert
    fromaddr = user
    toaddr = user   
    # instance of MIMEMultipart 
    msg = MIMEMultipart() 
      
    # storing the senders email address   
    msg['From'] = fromaddr 
      
    # storing the receivers email address  
    msg['To'] = toaddr 
      
    # storing the subject  
    msg['Subject'] = email_subject
      
    # string to store the body of the mail 
    body = email_body
      
    # attach the body with the msg instance 
    msg.attach(MIMEText(body, 'plain')) 
      
    # open the file to be sent  
    filename = email_attachment
    attachment = open(email_attachment, "rb") 
      
    # instance of MIMEBase and named as p 
    p = MIMEBase('application', 'octet-stream') 
      
    # To change the payload into encoded form 
    p.set_payload((attachment).read()) 
      
    # encode into base64 
    encoders.encode_base64(p) 
       
    p.add_header('Content-Disposition', "attachment; filename= %s" % filename) 
      
    # attach the instance 'p' to instance 'msg' 
    msg.attach(p) 
      
    # creates SMTP session 
    s = smtplib.SMTP('smtp.gmail.com', 587) 
      
    # start TLS for security 
    s.starttls() 
      
    # Authentication 
    s.login(fromaddr, password) 
      
    # Converts the Multipart msg into a string 
    text = msg.as_string() 
      
    # sending the mail 
    s.sendmail(fromaddr, toaddr, text) 
      
    # terminating the session 
    s.quit()
    print 'Email sent!'

    return True


# 2. XOR the cracked passwords with their corresponding shares to create a list of
#    valid shares that could then be used to try to recover the key


def main():
    success = False
    global EMAIL, PASSWORD
    while not success:
        current_json_file = args.inputfile
        current_pot_file = args.potfile
        pot_only_hashes, pot_only_passwords = read_pot_file(current_pot_file)
        ciphertext, hashes, shares = read_json_file(current_json_file)
        xored = []
        for h, s in zip(hashes, shares):
            for number, pot_h in enumerate(pot_only_hashes):
            	if h == pot_h:
                    xored.append(str(pxor(pot_only_passwords[number], s)))

        print "\n[1/5] Read in {} chars of ciphertext and {} hashes, {} of which are cracked".format(len(ciphertext), len(hashes), len(xored))

        if xored:
        # 3. Use the XORed shares to generate the key
            secret = sss.SecretSharer.recover_secret(xored)
            print "[2/5] The cracked passwords generated this key: {}".format(secret)

        # 4. Use the generated key to attempt to decrypt the next level and do a quick check to see if we managed to decrypt it
            print "[3/5] Using the key to attempt to decrypt the next level..."
            d = decrypt(ciphertext, secret)
            try:
                j = json.loads(d)
                cipher = len(j["ciphertext"])
                hashes = len(j["hashes"])
                print "      Looks like we unlocked the next level!"
                print "      It has {} chars of ciphertext and {} hashes.".format(cipher, hashes)
                print "      Here is the key that was used to unlock it: {}".format(secret)
                
                saveloc = current_json_file + ".unlocked.json"
                f = open(saveloc, "wb")
                f.write(d)
                f.close()
                print "[4/5] Saved what was decrypted to {}".format(saveloc)
                
                saveseceret = "00064-unlocked.secrets"
                s = open(saveseceret, "a+")
                s.write("\n%s" % secret)
                s.close()
                
                save_new_hashes = "new-locked.hashses"
                hs = open(save_new_hashes, "wb")
                for ln in j["hashes"]:
                    hs.write("%s\n" % ln)
                hs.close()

                print "[5/5] Saved the seceret key {} to and new hashes to {}".format(saveseceret,save_new_hashes)
                print "**********Congratulation!!!!*************"
                send_email(EMAIL,PASSWORD,'ALERT : THE NEXT LEVEL OF INFERNOBALL HAS BEEN UNLOCKED!!','The secret key : {}'.format(secret),saveloc)
                success = True

            except ValueError:
                success = False
                print "[4/5] Tough luck!!!!!!!"
                print "      We most likely don't have enough passwords cracked because what was decrypted doesn't look like a JSON"
                print "      But still, have a look at the output file to be extra sure!"
                time.sleep(5)
        else:
            success = False
            time.sleep(5)
            print "No passwords cracked yet...trying" 
           
if __name__ == "__main__":
    main()

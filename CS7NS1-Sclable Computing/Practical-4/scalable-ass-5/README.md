


##### rorys command rough work

http://us.download.nvidia.com/tesla/410.72/NVIDIA-Linux-x86_64-410.72.run
http://us.download.nvidia.com/tesla/384.81/NVIDIA-Linux-x86_64-384.81.run



blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off


awk '$1 ~ /^[0-9a-zA-Z]+$/' crackstation.txt | grep -o -w '\w\{8,8\}' > crackstation.txt.8letter
awk '$1 ~ /^[0-9a-zA-Z]+$/' crackstation.txt | grep -o -w '\w\{5,5\}' > crackstation.txt.5letter

grep -a -x '[0-9a-zA-Z]\{8,8\}' Downloads/crackstation/crackstation.txt > cs82.txt
LC_ALL='C' grep -a -x '[0-9a-zA-Z]\{5,5\}' crackstation.txt > cs5.txt

LC_ALL='C' grep -a -x '[0-9a-zA-Z]\{8,8\}' crackstation.txt > cs8.txt



15100


./hc -m 15100 level9.hashes.sha1 cs8.txt -O
./hc -m 15100 level9.hashes.sha1 cssmall.txt -O


 | sed -E 's/^\$pbkdf2-sha256\$(.+)\$(.+)\$(.+)/sha256:\1:\2:\3/g' | sed 's/\./+/g'



watchman -- trigger $(pwd) inferno 'level9/level9.pot' -- "python infernocode-v1.1.py -i level9/00064_hughesr8.as5.level9.json -p level9/level9.pot"

watchman watch-list
watchman watch-del-all


inferno, norton translation
http://www.dominiopublico.gov.br/download/texto/gu001995.pdf

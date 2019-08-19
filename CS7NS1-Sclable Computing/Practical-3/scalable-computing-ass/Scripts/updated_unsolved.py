import csv

cracked_list = []
with open("shaikhr.main.broken") as cracked_file:
    reader = csv.reader(cracked_file,delimiter = ' ')
    for row in reader:
     cracked_list.append(row[0])
     
main_list = []
with open("shaikhr.orig.hashes") as original_file:
    reader = csv.reader(original_file,delimiter = ' ')
    for row in reader:
      if row[0] in cracked_list:
        print('skipping :'+ row[0])
      else:
        main_list.append(row[0])

with open("unsolved_hash.hashes", "w") as new_file:
  for line in main_list:
    new_file.write("%s\n" % line)
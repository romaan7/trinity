import sys,csv

pot_file = sys.argv[1]
broken_file = "shaikhr.main.broken"
unsolved_file = "shaikhr.unsolved.hashes"

new_broken_file = broken_file + "_updated"

def update_solved():
  pot_dict = {}
  with open(pot_file) as pot:
    reader = csv.reader(pot,delimiter = ':')
    for row in reader:
     pot_dict.update({row[0]:row[1]})
  
  broken_dict={}
  with open(broken_file) as broken:
    reader1 = csv.reader(broken,delimiter = ' ')
    for row in reader1:
      broken_dict.update({row[0]:row[1]})
  
  final=dict(pot_dict,**broken_dict)
  
  with open(new_broken_file,'w',encoding='ascii') as new_file:
    for k, v in final.items():
      new_file.write(str(k) +' '+ str(v) + '\n')
  
  return 0

def update_unsolved():
  new_broken_list = []
  with open(new_broken_file) as new_broken:
    reader = csv.reader(new_broken,delimiter = ' ')
    for row in reader:
     new_broken_list.append(row[0])

  with open(unsolved_file+'_updated','w',encoding='utf8') as new_file:
   with open(unsolved_file) as unsolved:
      for line in unsolved.readlines():
        if line not in new_broken_list:
          new_file.write(line)
      
  return 0
  
  
def main():
    update_solved()
    update_unsolved()
    
    
if __name__ == "__main__":
  main()
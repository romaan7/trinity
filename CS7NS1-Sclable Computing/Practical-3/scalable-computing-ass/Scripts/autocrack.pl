#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec::Functions;

## This script has been tested on Linux and Windows. It works in both worlds.
##
## If you are on windows, you need to:
##
## - Install perl: http://www.activestate.com/activeperl
## - Install cygwin: http://cygwin.com/setup.exe
## - Uncomment and modify stuff in the local installation paths section
##
## Regardless of which System OS you are using:
##
## Make sure to modify the local dictionary paths in @dicts_globs
##

##
## Local installation paths
##

my $home_oclHashcat_plus  = "/root/oclHashcat-plus-0.08/";
my $home_hashcat_utils    = "/root/hashcat-utils-0.6/";
my $home_sort             = "/usr/bin/";
my $cmd_oclHashcat_plus   = "oclHashcat-plus64.bin";
my $cmd_expander          = "expander.bin";
my $cmd_sort              = "sort";

#my $home_oclHashcat_plus  = "d:\\tools\\oclHashcat-plus-0.08\\";
#my $home_hashcat_utils    = "d:\\tools\\hashcat-utils-0.6\\";
#my $home_sort             = "c:\\cygwin\\bin";
#my $cmd_oclHashcat_plus   = "oclHashcat-plus64.exe";
#my $cmd_expander          = "expander.exe";
#my $cmd_sort              = "sort.exe";

##
## Local dictionary paths
##

my @dicts_globs =
(
  "/root/dict/*.txt",
  "/root/dict/*.dict",
  "/root/dict/*.exp",
  "/root/dict2/*.txt",
  "/root/dict2/*.exp",
  "/root/dict2/*.dic*",
  "/root/dict4/onlythis.txt",

  #"d:\\dict3\\*.txt",
  #"d:\\dict3\\*.dict",
  #"d:\\dict3\\*.exp",
  #"d:\\dict2\\*.txt",
  #"d:\\dict2\\*.exp",
  #"d:\\dict2\\*.dic*",
  #"d:\\dict4\\onlythis.txt",
);

##
## Local misc paths
##

my $cracked_pot  = "acp.cracked.pot";
my $tmpdir       = File::Spec->tmpdir ();

##
## oclHashcat-plus parameters
##

my $hash_type = 0;
my $gpu_accel = 80;
my $gpu_loops = 1024;

my @extra_flags =
(
  "--quiet",
  "--force",
  "--remove",
  "--runtime", 60 * 10,
);

##
## If you set this to 1 it steps through each bf mask once and quits afterwards
##

my $bf_run = 0;

## Specify the attack types to run
##
##  0 = Temporary dictionary + single rule file (Straight)
##  1 = Temporary dictionary + multi rule files (Straight)
##  2 = Temporary dictionary + generated rules (Straight)
##  3 = Temporary dictionary + expanded dictionary (Fingerprint)
##  4 = Expanded dictionary + Temporary dictionary (Fingerprint)
##  5 = Temporary dictionary + Temporary dictionary (Combinator)
##  6 = Temporary dictionary + Mask (Hybrid)
##  7 = Mask + Temporary dictionary (Hybrid)
##  8 = Expanded dictionary + Mask (Fingerprint)
##  9 = Mask + Expanded dictionary (Fingerprint)
## 10 = Temporary dictionary + Permutation (Permutation)
## 11 = Mask (BF)
##
## NOTE: If you double-list a specific number you raise the chances of selecting it

my @attacks = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11);

##
## if you think the attacks run too fast increase this.
## but, do not set to zero and do not oversize this
##

my $temp_size = 120000;

##
## bf masks
##

my @bf_masks =
(
  "?1",
  "?1?1",
  "?1?1?1",
  "?1?1?1?1",
  "?1?1?1?1?1",
  "?1?1?1?1?d?d",
  "?1?1?1?4?l?l",
  "?d?d?1?1?1?1",
  "?l?l?4?1?1?1",
  "?1?1?1?1?l?d?d",
  "?1?1?1?4?d?d?d",
  "?1?1?4?4?l?l?d",
  "?1?4?4?4?d?d?l",
  "?1?4?4?4?l?l?l",
  "?1?4?4?4?l?l?s",
  "?1?4?4?4?l?s?s",
  "?1?4?4?4?u?u?u",
  "?3?4?4?4?d?l?l",
  "?3?4?4?4?l?l?d",
  "?d?d?1?1?1?1?l",
  "?d?d?d?4?1?1?1",
  "?d?l?l?1?4?4?1",
  "?d?l?l?4?4?4?3",
  "?l?l?l?4?4?4?1",
  "?s?l?l?4?4?4?1",
  "?1?1?4?4?d?d?d?d",
  "?1?4?4?4?d?d?d?l",
  "?3?4?4?4?d?d?l?l",
  "?3?4?4?4?l?l?d?d",
  "?4?4?d?d?d?d?d?d",
  "?d?d?d?d?4?4?1?1",
  "?d?d?d?d?d?d?4?4",
  "?d?d?l?l?4?4?4?3",
  "?d?l?l?d?4?4?4?3",
  "?l?d?d?4?4?4?4?1",
  "?l?l?d?d?4?4?4?3",
  "?l?l?l?l?l?l?l?l",
  "?s?l?l?l?4?4?4?4",
  "?u?u?u?u?4?4?4?4",
  "?u?u?u?u?u?u?u?u",
  "?4?4?d?d?d?d?d?d?d",
  "?d?d?d?d?d?d?d?4?4",
  "?l?d?d?d?4?4?4?4?1",
  "?4?4?d?d?d?d?d?d?d?d",
  "?d?d?d?d?d?d?d?d?4?4",
);

##
## hybrid masks
##

my @hybrid_masks =
(
  "?d",
  "?d?d",
  "?d?d?d",
  "?d?d?d?d",
  "?d?d?d?d?d",
  "?d?d?d?d?l",
  "?d?d?d?l",
  "?d?d?d?l?l",
  "?d?d?l",
  "?d?d?l?l",
  "?d?d?l?l?l",
  "?d?l?l",
  "?d?l?l?l",
  "?l?d?d",
  "?l?d?d?d",
  "?l?l?d",
  "?l?l?d?d",
  "?l?l?l",
  "?l?l?l?d",
  "?l?l?l?l",
  "?u?d?d?d",
  "?u?l?d?d",
  "?u?l?l?d",
  "?u?l?l?l",
  "?1",
  "?1?1",
  "?1?1?1",
  "?2",
  "?2?2",
  "?2?2?2",
  "?2?2?2",
  "?3",
  "?3?3",
  "?3?3?3",
  "?4",
  "?4?4",
  "?4?4?4",
  "?4?4?4?4",
);

##
## static (example or user-defined) rules
##

my $rules_path = catdir ($home_oclHashcat_plus, "rules");

my @single_rule_files =
(
  catfile ($rules_path, "best64.rule"),
  catfile ($rules_path, "T0XlC.rule"),
  catfile ($rules_path, "d3ad0ne.rule"),
  catfile ($rules_path, "toggles3.rule"),
  catfile ($rules_path, "toggles4.rule"),
  catfile ($rules_path, "toggles5.rule"),
);

##
## multi rules (taken out of best64.rule)
##

my @multi_rule_file0 =
(
  ':',
  'l',
  'c',
  'u',
  't',
  'Z1',
  'd',
  'sa@',
  'se3',
  '$0',
  '$1',
  '$2',
  '$3',
  '$4',
  '$5',
  '$6',
  '$7',
  '$8',
  '$9',
  '$0 $1',
  '$1 $2',
  '$1 $2 $3',
);

my @multi_rule_file1 =
(
  'D1',
  'D2',
  'D3',
  'D4',
  'D5',
  'D6',
  '\'7',
  '\'8',
  '\'9',
  '[',
  '[[',
  '[[[',
  '[[[[',
  ']',
  ']]',
  ']]]',
  ']]]]',
  '[    $1',
  '[[   $1',
  '[[[  $1',
  '[[[[ $1',
);

my @multi_rule_file2 =
(
  'c $0',
  'c $1',
  'c $0 $1',
  'c $1 $2',
  'c $1 $2 $3',
  '$2 $0 $0 $0',
  '$2 $0 $0 $1',
  '$2 $0 $0 $2',
  '$2 $0 $0 $3',
  '$2 $0 $0 $4',
  '$2 $0 $0 $5',
  '$2 $0 $0 $6',
  '$2 $0 $0 $7',
  '$2 $0 $0 $8',
  '$2 $0 $0 $9',
  '$2 $0 $1 $0',
  '$2 $0 $1 $1',
  '$2 $0 $1 $2',
  '$s',
  '$e $d',
  '$i $n $g',
);

my $hybrid_path = catdir ($rules_path, "hybrid");

my @multi_rule_files =
(
  catfile ($tmpdir, "acp.r1.rule"), ## do not change this
  catfile ($tmpdir, "acp.r2.rule"), ## do not change this
  catfile ($tmpdir, "acp.r3.rule"), ## do not change this

  catfile ($hybrid_path, "append_d.rule"),
  catfile ($hybrid_path, "append_ds.rule"),
  catfile ($hybrid_path, "append_du.rule"),
  catfile ($hybrid_path, "append_dus.rule"),
  catfile ($hybrid_path, "append_hl.rule"),
  catfile ($hybrid_path, "append_hu.rule"),
  catfile ($hybrid_path, "append_l.rule"),
  catfile ($hybrid_path, "append_ld.rule"),
  catfile ($hybrid_path, "append_lds.rule"),
  catfile ($hybrid_path, "append_ldu.rule"),
  catfile ($hybrid_path, "append_ldus.rule"),
  catfile ($hybrid_path, "append_ls.rule"),
  catfile ($hybrid_path, "append_lu.rule"),
  catfile ($hybrid_path, "append_lus.rule"),
  catfile ($hybrid_path, "append_s.rule"),
  catfile ($hybrid_path, "append_u.rule"),
  catfile ($hybrid_path, "append_us.rule"),
  catfile ($hybrid_path, "prepend_d.rule"),
  catfile ($hybrid_path, "prepend_ds.rule"),
  catfile ($hybrid_path, "prepend_du.rule"),
  catfile ($hybrid_path, "prepend_dus.rule"),
  catfile ($hybrid_path, "prepend_hl.rule"),
  catfile ($hybrid_path, "prepend_hu.rule"),
  catfile ($hybrid_path, "prepend_l.rule"),
  catfile ($hybrid_path, "prepend_ld.rule"),
  catfile ($hybrid_path, "prepend_lds.rule"),
  catfile ($hybrid_path, "prepend_ldu.rule"),
  catfile ($hybrid_path, "prepend_ldus.rule"),
  catfile ($hybrid_path, "prepend_ls.rule"),
  catfile ($hybrid_path, "prepend_lu.rule"),
  catfile ($hybrid_path, "prepend_lus.rule"),
  catfile ($hybrid_path, "prepend_s.rule"),
  catfile ($hybrid_path, "prepend_u.rule"),
  catfile ($hybrid_path, "prepend_us.rule"),
);

##
## Permutation attack limit. Only change if you know what you are doing!
##

my $perm_min = 8;
my $perm_max = 10;

##
## Custom charsets. Only change if you know what you are doing!
##

my $charset_1 = "?l?d?s?u";
my $charset_2 = "?l?d?s";
my $charset_3 = "?l?d?u";
my $charset_4 = "?l?d";

##
## main
##

if (!-e $home_oclHashcat_plus)
{
  chdir ($home_oclHashcat_plus);

  die ("$home_oclHashcat_plus: $!$/");
}

if (!-e $home_hashcat_utils)
{
  chdir ($home_hashcat_utils);

  die ("$home_hashcat_utils: $!$/");
}

my $hash_file = $ARGV[0] || die ("usage: $0 hashlist$/");

$SIG{"INT"} = \&cleanup;

select STDERR; $| = 1;
select STDOUT; $| = 1;

chdir ($home_oclHashcat_plus) || die ("$home_oclHashcat_plus: $!$/");

my $cracked_cur  = catfile ($tmpdir, "acp.cracked.cur");
my $tpl_tempdict = catfile ($tmpdir, "acp.%04d.dict");

if ($bf_run)
{
  for my $mask (@bf_masks)
  {
    append_data ($cracked_cur, $cracked_pot);

    my $num_cracked = count_lines ($cracked_pot);

    puts ("[*] Hashes cracked: $num_cracked$/");

    unlink ($cracked_cur);

    puts ("[*] Running attack: Mask ($mask)");

    run_oclHashcat (11, $mask);
  }

  exit;
}

##
## find dicts
##

my @dicts;

for my $dicts_glob (@dicts_globs)
{
  puts ("[*] Scanning dictionary mask: $dicts_glob");

  for my $dict (glob ($dicts_glob))
  {
    next unless (-s $dict);

    puts ("[*] Adding dictionary: $dict");

    push (@dicts, $dict);
  }

  puts ("");
}

if (scalar @dicts == 0)
{
  warn "$/$/No dictionaries found, giving up...$/$/";

  exit;
}

##
## create temp multi rules
##

open (RULES0, ">", $multi_rule_files[0]);
open (RULES1, ">", $multi_rule_files[1]);
open (RULES2, ">", $multi_rule_files[2]);

print RULES0 join ($/, @multi_rule_file0), $/;
print RULES1 join ($/, @multi_rule_file1), $/;
print RULES2 join ($/, @multi_rule_file2), $/;

close (RULES0);
close (RULES1);
close (RULES2);

##
## run loop
##

puts ("[*] Starting main loop");

my @temp_dicts;

while (-s $hash_file)
{
  append_data ($cracked_cur, $cracked_pot);

  unlink ($cracked_cur);

  my $num_cracked = count_lines ($cracked_pot);

  puts ("[*] Hashes cracked: $num_cracked$/");

  ##
  ## Pick random dict
  ##

  my $dict;

  if (scalar @temp_dicts < 2)
  {
    my $dict_num = get_random_num (0, scalar @dicts);

    my $dict = $dicts[$dict_num];

    @temp_dicts = gen_temp_dict ($dict, $temp_size);
  }

  next if (scalar @temp_dicts < 2);

  my $temp_dicts_left = scalar @temp_dicts;
  my $temp_dict_num = get_random_num (0, $temp_dicts_left);
  my $temp_dict = splice @temp_dicts, $temp_dict_num, 1;
  my $temp_dict_exp = sprintf ("%s.exp", $temp_dict);

  my $temp_dicts_left2 = scalar @temp_dicts;
  my $temp_dict2_num = get_random_num (0, $temp_dicts_left2);
  my $temp_dict2 = splice @temp_dicts, $temp_dict2_num, 1;
  my $temp_dict2_exp = sprintf ("%s.exp", $temp_dict2);

  ##
  ## Pick random hybrid mask
  ##

  my $hybrid_mask_num = get_random_num (0, scalar @hybrid_masks);

  my $hybrid_mask = $hybrid_masks[$hybrid_mask_num];

  ##
  ## Pick random bf mask
  ##

  my $bf_mask_num = get_random_num (0, scalar @bf_masks);

  my $bf_mask = $bf_masks[$bf_mask_num];

  ##
  ## Pick random rules : why not the same twice?
  ##

  my $single_rule_files_num = get_random_num (0, scalar @single_rule_files);

  my $single_rule_file = $single_rule_files[$single_rule_files_num];

  my $multi_rule_files_1_num = get_random_num (0, scalar @multi_rule_files);
  my $multi_rule_files_2_num = get_random_num (0, scalar @multi_rule_files);

  my $multi_rule_files_1 = $multi_rule_files[$multi_rule_files_1_num];
  my $multi_rule_files_2 = $multi_rule_files[$multi_rule_files_2_num];

  my $generate_rules = get_random_num (0, 50000);

  ##
  ## run attack
  ##

  my $num_attack_rnd = get_random_num (0, scalar @attacks);

  my $num_attack = $attacks[$num_attack_rnd];

  if ($num_attack == 0)
  {
    puts ("[*] Running attack: Temporary dictionary + single rule file (Straight)");

    run_oclHashcat ($num_attack, $temp_dict, $single_rule_file);
  }
  elsif ($num_attack == 1)
  {
    puts ("[*] Running attack: Temporary dictionary + multi rule files (Straight)");

    run_oclHashcat ($num_attack, $temp_dict, $multi_rule_files_1, $multi_rule_files_2);
  }
  elsif ($num_attack == 2)
  {
    puts ("[*] Running attack: Temporary dictionary + generated rules (Straight)");

    run_oclHashcat ($num_attack, $temp_dict, $generate_rules);
  }
  elsif ($num_attack == 3)
  {
    puts ("[*] Running attack: Temporary dictionary + expanded dictionary (Fingerprint)");

    expand_dict ($temp_dict2, $temp_dict2_exp);

    run_oclHashcat ($num_attack, $temp_dict, $temp_dict2_exp);
  }
  elsif ($num_attack == 4)
  {
    puts ("[*] Running attack: Expanded dictionary + Temporary dictionary (Fingerprint)");

    expand_dict ($temp_dict, $temp_dict_exp);

    run_oclHashcat ($num_attack, $temp_dict_exp, $temp_dict);
  }
  elsif ($num_attack == 5)
  {
    puts ("[*] Running attack: Temporary dictionary + Temporary dictionary (Combinator)");

    run_oclHashcat ($num_attack, $temp_dict, $temp_dict2);
  }
  elsif ($num_attack == 6)
  {
    puts ("[*] Running attack: Temporary dictionary + Mask (Hybrid)");

    run_oclHashcat ($num_attack, $temp_dict, $hybrid_mask);
  }
  elsif ($num_attack == 7)
  {
    puts ("[*] Running attack: Mask + Temporary dictionary (Hybrid)");

    run_oclHashcat ($num_attack, $hybrid_mask, $temp_dict);
  }
  elsif ($num_attack == 8)
  {
    puts ("[*] Running attack: Expanded dictionary + Mask (Fingerprint)");

    expand_dict ($temp_dict, $temp_dict_exp);

    run_oclHashcat ($num_attack, $temp_dict_exp, $hybrid_mask);
  }
  elsif ($num_attack == 9)
  {
    puts ("[*] Running attack: Mask + Expanded dictionary (Fingerprint)");

    expand_dict ($temp_dict2, $temp_dict2_exp);

    run_oclHashcat ($num_attack, $hybrid_mask, $temp_dict2_exp);
  }
  elsif ($num_attack == 10)
  {
    puts ("[*] Running attack: Temporary dictionary + Permutation (Permutation)");

    run_oclHashcat ($num_attack, $temp_dict);
  }
  elsif ($num_attack == 11)
  {
    puts ("[*] Running attack: Mask (BF)");

    run_oclHashcat ($num_attack, $bf_mask);
  }

  unlink ($temp_dict);
  unlink ($temp_dict_exp);

  unlink ($temp_dict2);
  unlink ($temp_dict2_exp);
}

puts ("[*] Stopping main loop");

sub puts
{
  my $line = shift;

  print $line, $/;
}

sub expand_dict
{
  my $infile = shift;

  my $outfile = shift;

  print ("[*] Running expander ... ");

  my $path_expander = catfile ($home_hashcat_utils, $cmd_expander);

  my $path_sort = catfile ($home_sort, $cmd_sort);

  my @cmd = ("$path_expander < $infile | $path_sort --unique --temporary-directory $tmpdir --output $outfile");

  my_system (@cmd);

  print (" Done!$/");
}

sub append_data
{
  my $infile  = shift;

  my $outfile = shift;

  open (IN, "<", $infile) or return;

  open (OUT, ">>", $outfile) or return;

  while (my $line = <IN>)
  {
    chomp ($line);

    print OUT $line, $/;
  }

  close (OUT);

  close (IN);
}

my $db_attack;

sub run_oclHashcat
{
  my $num_attack = shift;

  my $map_attack_mode = [0, 0, 0, 1, 1, 1, 6, 7, 6, 7, 4, 3];

  my $attack_mode = $map_attack_mode->[$num_attack];

  my $path_oclHashcat_plus = catfile ($home_oclHashcat_plus, $cmd_oclHashcat_plus);

  my @cmd =
  (
    $path_oclHashcat_plus,

    "--hash-type",       $hash_type,
    "--attack-mode",     $attack_mode,
    "--outfile",         $cracked_cur,
    "--gpu-accel",       $gpu_accel,
    "--gpu-loops",       $gpu_loops,
    "--custom-charset1", $charset_1,
    "--custom-charset2", $charset_2,
    "--custom-charset3", $charset_3,
    "--custom-charset4", $charset_4,

    @extra_flags,

    $hash_file
  );

  if ($attack_mode == 0)
  {
    my $dict = shift;

    if ($num_attack == 0)
    {
      my $rule = shift;

      push (@cmd, $dict, "--rules-file", $rule);
    }
    elsif ($num_attack == 1)
    {
      my $rule_1 = shift;
      my $rule_2 = shift;

      push (@cmd, $dict, "--rules-file", $rule_1, "--rules-file", $rule_2);
    }
    elsif ($num_attack == 2)
    {
      my $generate_rules = shift;

      push (@cmd, $dict, "--generate-rules", $generate_rules);
    }
  }
  elsif ($attack_mode == 1)
  {
    my $dict_r = shift;
    my $dict_l = shift;

    push (@cmd, $dict_r, $dict_l);
  }
  elsif ($attack_mode == 3)
  {
    my $mask = shift;

    if (exists $db_attack->{$num_attack}->{$mask})
    {
      $db_attack->{$num_attack}->{$mask} = undef;

      puts ("[*] Skipping attack, already done ...$/");

      return;
    }

    push (@cmd, $mask);
  }
  elsif ($attack_mode == 4)
  {
    my $dict = shift;

    push (@cmd, $dict, "--perm-min", $perm_min, "--perm-max", $perm_max);
  }
  elsif ($attack_mode == 6)
  {
    my $dict_l = shift;
    my $mask_r = shift;

    push (@cmd, $dict_l, $mask_r);
  }
  elsif ($attack_mode == 7)
  {
    my $mask_l = shift;
    my $dict_r = shift;

    push (@cmd, $mask_l, $dict_r);
  }

  my $time_start = time;

  print ("[*] Executing $cmd_oclHashcat_plus ... ");

  my_system (@cmd);

  my $time_stop = time;

  my $num_sec = $time_stop - $time_start;

  print ("done in $num_sec seconds.$/");

  # gives the user a chance to interrupt the loop

  sleep (1);
}

sub count_lines
{
  my $file = shift;

  my $count = 0;

  open (IN, $file) or return 0;

  while (my $line = <IN>) { $count++ }

  close (IN);

  return $count;
}

sub get_random_num
{
  my $min = shift;
  my $max = shift;

  return int ((rand ($max - $min)) + $min);
}

sub gen_temp_dict
{
  my $dict = shift;

  my $words = shift;

  ##
  ## generate new temp dictionary
  ##

  my @temp_dicts;

  my $num = 0;

  my $cur = 0;

  my $IN; my $OUT;

  open ($IN, "<", $dict) or die ("$dict: $!$/");

  while (my $line = <$IN>)
  {
    if (($cur % $words) == 0)
    {
      close $OUT if defined $OUT;

      my $temp_dict = sprintf ($tpl_tempdict, $num);

      push (@temp_dicts, $temp_dict);

      print ("\r[*] Creating temporary dictionary: $temp_dict");

      open ($OUT, ">", $temp_dict) or die ("$temp_dict: $!$/");

      $num++;
    }

    print $OUT $line;

    $cur++;
  }

  close $OUT if defined $OUT;

  close $IN;

  print ("\r[*] Created temporary dictionaries out of dictionary: $dict$/");

  return @temp_dicts;
}

sub cleanup
{
  unlink $cracked_cur;

  unlink $multi_rule_files[0];
  unlink $multi_rule_files[1];
  unlink $multi_rule_files[2];

  for (my $i = 0; $i < 10000; $i++)
  {
    my $filename = sprintf ($tpl_tempdict, $i);

    unlink ($filename);
    unlink ($filename . ".exp");
  }

  warn "$/$/... cleaning up ...$/$/";

  exit;
}

sub my_system
{
  my @cmd = @_;

  system (@cmd);

  my $rc = 0;

  if ($? == -1)
  {
    $rc = -1;
  }
  elsif ($? & 127)
  {
    $rc = $? & 127;
  }
  else
  {
    $rc = $? >> 8;
  }

  if ($rc)
  {
    my $cmdline = join (" ", @cmd);

    puts ("[*] ERROR: Got invalid returncode '$rc' after executing following cmdline: ");
    puts ($cmdline);
    puts ($!);
    puts ("");

    cleanup ();

    exit -1;
  }
}

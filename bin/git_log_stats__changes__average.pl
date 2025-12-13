#!/usr/bin/perl
#= git_log_stats__changes__average.pl

use POSIX;

#: > git_log_stats__changes.sh | head
#: 2025-12-09 00:49:27 +0100, a0c1d52, GITSTATS:F:1:I:1:D:1, GITCHANGES:2, [0.8.7] {0} <web_ui> bug fix in web_ui/src/components/RemContMonComponent.vue .
#: 2025-12-09 00:14:30 +0100, c2faa91, GITSTATS:F:2:I:5:D:3, GITCHANGES:8, post-add files belonging to previous commit.
#: 2025-12-09 00:11:54 +0100, c97e3ca, GITSTATS:F:1:I:4:D:0, GITCHANGES:4, post-added files belonging to previous commit.
#: 2025-12-09 00:05:03 +0100, 5ad907c, GITSTATS:F:5:I:545:D:1, GITCHANGES:546, [0.8.6] {1} <multiple> 1: moved hard-coded config in dimp.js:post_url and dproc.js:run_func_url to site-static-config.json: .sections.dimp|dproc.base_api_url
#: 2025-12-08 13:30:42 +0700, 8b53305, GITSTATS:F:4:I:45:D:5, GITCHANGES:50, Updates for dockers Some ip addresses are still hard coded!
#: 2025-11-28 10:38:53 +0100, 4098246, GITSTATS:F:13:I:326:D:9, GITCHANGES:335, [0.8.5] {0} <system> update /site-static-config.example.json for new mqtt_mcs = mcs-server-2.dcs-mgt.nl 

my $COUNT = 0;
my $TOTAL = 0;
my $AVERAGE = 0;

my $MAX_NORMAL = 8000;
my $ASSUMPTION_AVERAGE = 191;

while (my $LINE=<>) {
  chomp($LINE);
  # print "#== $LINE ==# \n";

  my $GITCHANGES = $LINE;
  $GITCHANGES =~ s/^.*GITCHANGES:(\d+).*$/$1/;
  $GITCHANGES += 0;
  if ($GITCHANGES > $MAX_NORMAL) {
    $GITCHANGES = 0;
  }
  # print "GITCHANGES=$GITCHANGES -- $LINE \n";
  # print "$GITCHANGES -- $LINE \n";

  my $HOURS = $LINE;
  if ($HOURS =~ /{(\d+)}/) {
    $HOURS = $1+0;
  } else {
    $HOURS = 0;
  }
  # print "HOURS=$HOURS -- $LINE \n";
  # print "$HOURS -- $LINE \n";

  my $AVG = 0;
  if ($HOURS == 0) {
    $AVG = 0;
  } else {
    $AVG = floor($GITCHANGES / $HOURS);
  }
  # print "AVG=$AVG -- $LINE \n";

  $LINE =~ /^(.*?GITCHANGES:\d+), (.*)$/;
  my $PART1 = $1;
  my $PART2 = $2;

  my $NEWLINE = "";
  # 
  # $NEWLINE = "$PART1, AVG_LINES_PER_HOUR:$AVG, $PART2";
  # 
  my $CALC_HOURS = $HOURS;
  if ($HOURS == 0) {
    # $CALC_HOURS = round($GITCHANGES / $ASSUMPTION_AVERAGE);
    $CALC_HOURS = int(($GITCHANGES / $ASSUMPTION_AVERAGE) + 0.5);
  }
  $NEWLINE = "$PART1, AVG_LINES_PER_HOUR:$AVG, CALC_HOURS:$CALC_HOURS, $PART2";
  # 
  print "$NEWLINE \n";

  if ($AVG != 0) {
    $COUNT += 1;
    $TOTAL += $AVG
  }
  if ($COUNT != 0) {
    $AVERAGE = floor($TOTAL / $COUNT);
  }
} #\ while (my $LINE=<>) {}

print "## TOTAL AVERAGE of set(AVG_LINES_PER_HOUR>0) = $AVERAGE with COUNT(AVG_LINES_PER_HOUR>0) = $COUNT .\n";

#-eof


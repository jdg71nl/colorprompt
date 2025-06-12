#!/usr/bin/perl
#= append_slash.pl
while(<>){
	my $s = $_ ;
	chomp($s);
	printf"%s\/\n",$s;
}


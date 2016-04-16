#!/usr/bin/perl
# Listen ITvilla Barionet controller(s) on UDP port 50000 and forward
# data to Nagios
#
# Cougar 2013-08-01
#
# based on http://moneath.blogspot.com/2006/04/udp-server-with-xinetd-and-perl.html
#
use strict;
use IO::Socket;
use IO::Select;

my $maxlen = 255;

open (CMD_OUT, "> /var/log/nagios/rw/nagios.cmd") or die "Can't open Nagios cmd pipe: $!";

my $read_set = new IO::Select();
$read_set->add(\*STDIN);

while (my @ready = $read_set->can_read(0)) {
	foreach my $rh (@ready) {
		if ($rh == \*STDIN) {
			my $command;
			my $return_addr = recv(STDIN, $command, $maxlen, 0) || die "recv: $!";
			syswrite CMD_OUT, $command, $maxlen;
		}
	}
}

#!/usr/bin/perl -w
use strict;

# mnx.pl - backend for Minimal NWNX
#
# shamelessly based on Cookbook ex.17-2, udpquotd.pl
#
# listens for requests on udp 1820

use IO::Socket;
use vars  qw/$sock $inpkt $outpkt $hisaddr $hishost $PORTNO $CMDLINE/;

$PORTNO = 2182;
$CMDLINE = '/usr/bin/fortune -s';
# $CMDLINE = 'date';

sub pktdump($) {
  my ($pkt) = @_;
  my ($chrout,$length, $i,$j);

  $length= length($pkt);

  for($j=0; $j<$length; ) {
	$chrout = "                ";
	for($i=0; $i<16 && $j<$length; ++$i ) {
	  my $hexval = ord(substr($pkt,$j,1));
	  my $hexstr = pack('H*',$hexval);
	  printf(" %02x",$hexval);
	  substr($chrout,$i,1) = ($hexval>31 && $hexval<128)?chr($hexval):".";
	  ++$j;
	}
	while($i<16) {
	  print "   ";
	  ++$i;
	}
	print " - $chrout\n";
  }
}

sub process_request($) {
  my ($request) = @_;
  my ($reqtype,$args,$dump) = ( "","","");

  ($reqtype,$args,$dump) = split(/[!]/,$request,3);
  my ($result);

  print "Request: $reqtype, Arguments: $args\n";
  
  if($reqtype eq "date") {
    $result=`date`;
   } elsif($reqtype eq "load") {
    $result=`cat /proc/loadavg`;
   } elsif($reqtype eq "fortune") {
    $result=`/usr/bin/fortune -s`;
   } elsif($reqtype eq "mem") {
    $result=`head -3 /proc/meminfo`;
   } else {
    $result="Unknown request!";
   }

  return $result;
} 

$sock = IO::Socket::INET->new(LocalHost => "127.0.0.1", LocalPort => $PORTNO, Proto => 'udp')
 or die "socket: $@";
print "Listening to UDP $PORTNO\n";

while($sock->recv($inpkt,1024)) {
  my ($port, $ipaddr) = sockaddr_in($sock->peername);
  # my ($nwnx,$op,$arg,$value) = split(/[!]/,$inpkt,4);

  # print "Received $op $arg from " . inet_ntoa($ipaddr) . ":$port\n";
  print "Received $inpkt from " . inet_ntoa($ipaddr) . ":$port\n";

  my $output = process_request($inpkt); # . "¬";
  print "$output\n";

  $sock->send($output);
}
die "recv: $!";

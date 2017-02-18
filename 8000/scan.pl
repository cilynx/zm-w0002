#!/usr/bin/perl

use IO::Socket::INET;

$| = 1;

for(my $x = 0; $x < 255; $x++)
{
   for(my $y = 0; $y < 255; $y++)
   {
      my $socket = new IO::Socket::INET (
	 PeerHost => '192.168.1.170',
	 PeerPort => '8000',
	 Proto => 'tcp',
	 Reuse => 1
      );

      die "cannot connect to the server $!\n" unless $socket;

      $hex_x = pack("c", $x);
      $hex_y = pack("c", $y);

      my $req = "\x55\x55\xaa\xaa\x00\x00\x00\x00\x00\x00" . $hex_x . $hex_y;
      my $size = $socket->send($req);

      shutdown($socket, 1);

      my $response = "";
      $socket->recv($response, 1024);
      #print "received response: $response\n";
      if($response) {
	 print unpack("H2", pack("c",$x)), ", ", unpack("H2", pack("c",$y)), ", ", unpack("H*", $response), "$response\n";
      }

      $socket->close();
   }
}

#!/usr/bin/perl
#= generate_random_number_32bits_min_0_max_4294967295.pl

# - - - - - - = = = - - - - - - . 

# sudo apt install libcrypt-openssl-random-perl
# https://packages.debian.org/sid/libcrypt-openssl-random-perl
# use Crypt::OpenSSL::Random;
# https://metacpan.org/pod/Crypt::OpenSSL::Random


#use Crypt::OpenSSL::Random;
#use Data::Dumper;
#
#Crypt::OpenSSL::Random::random_seed($good_random_data);
#Crypt::OpenSSL::Random::random_egd("/tmp/entropy");
#Crypt::OpenSSL::Random::random_status() or die "Unable to sufficiently seed the random number generator";
#
#my $ten_good_random_bytes = Crypt::OpenSSL::Random::random_bytes(4);
#my $ten_ok_random_bytes = Crypt::OpenSSL::Random::random_pseudo_bytes(10);
#
#print Dumper($ten_good_random_bytes)
#printf ("%lX ", $ten_good_random_bytes);

# - - - - - - = = = - - - - - - . 

# sudo apt install libbytes-random-secure-perl
# https://metacpan.org/pod/Bytes::Random::Secure

#use Bytes::Random::Secure qw(
#  random_bytes random_bytes_base64 random_bytes_hex
#);
#my $bytes = random_bytes(32); # A string of 32 random bytes.
#my $bytes = random_string_from( 'abcde', 10 ); # 10 random a,b,c,d, and e's.
#my $bytes_as_base64 = random_bytes_base64(57); # Base64 encoded rand bytes.
#my $bytes_as_hex = random_bytes_hex(8); # Eight random bytes as hex digits.
#my $bytes_as_quoted_printable = random_bytes_qp(100); # QP encoded bytes.
#my $random = Bytes::Random::Secure->new(
#  Bits        => 64,
#  NonBlocking => 1,
#); # Seed with 64 bits, and use /dev/urandom (or other non-blocking).
#my $bytes = $random->bytes(32); # A string of 32 random bytes.
#my $long  = $random->irand;     # 32-bit random integer.

use Bytes::Random::Secure;

my $random = Bytes::Random::Secure->new(
  Bits        => 64,
  NonBlocking => 1,
); # Seed with 64 bits, and use /dev/urandom (or other non-blocking).

my $long  = $random->irand;     # 32-bit random integer.

printf ("%d", $long);

#-eof


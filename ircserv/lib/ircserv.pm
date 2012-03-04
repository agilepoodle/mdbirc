package ircserv;

use Dancer ':syntax';
use MongoDB;
use MongoDB::OID;

use Data::Dumper;

our $VERSION = '0.1';

# Initialize MongoDB connection on default port
my $conn = MongoDB::Connection->new(host => 'localhost', port => 27017);
my $db = $conn->mdbirc;
my $coll = $db->irc;


get '/' => sub {
    my $irc_lines = $coll->find->limit(100);
    my @irc = $irc_lines->all;
    debug("irc ontent", \@irc);
    template 'latest',  \@irc;
};

true;

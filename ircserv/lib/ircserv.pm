package ircserv;

use Dancer ':syntax';
use Template;
use MongoDB;
use MongoDB::OID;

use Data::Dumper;

our $VERSION = '0.1';

set 'template'     => 'template_toolkit';

# Initialize MongoDB connection on default port
my $conn = MongoDB::Connection->new(host => 'localhost', port => 27017);
my $db = $conn->mdbirc;
my $coll = $db->irc;


get '/' => sub {
    my $irc_lines = $coll->find->limit(100);
    my %found_lines = ( 'irc' => [] );
    push @{ $found_lines{'irc'} }, $irc_lines->all();
    debug(%found_lines);
    template 'latest',  \%found_lines;
};

get '/tag/:tag' => sub {
    my $tag = params->{tag};
    my $irc_lines = $coll->find({'tags' => $tag})->limit(100);
    my %found_lines = ( 'irc' => [] );
    push @{ $found_lines{'irc'} }, $irc_lines->all();
    debug(%found_lines);
    template 'tags',  \%found_lines, { layout => 'tags' };
};

true;

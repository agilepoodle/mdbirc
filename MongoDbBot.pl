#! /usr/bin/perl

use strict;
use warnings;

package MongoDbBot;

use base qw( Bot::BasicBot );

use MongoDB;
use MongoDB::OID;
use Data::Dumper;

my $tags_re = qr{\#(\w+)}mx;

my $conn;
my $db;
my $coll;

sub init {
    # Initialize MongoDB connection on default port
    $conn = MongoDB::Connection->new(host => 'localhost', port => 27017);
    $db = $conn->mdbirc;
    $coll = $db->irc;
    $coll->ensure_index({'channel' => 1, 'nick' => 1, 'tags' => 1});
    return 1;
} 

sub said {
    my ($self, $msg) = @_;

    my $mongo = {
	'channel' => $msg->{channel},
	'nick' => $msg->{who},
	'msg' => $msg->{body},
	'tags' => (),
	'date' => time(),
    };

    push @{ $mongo->{tags} }, $self->find_tags($msg->{body});

    $coll->save($mongo, {'safe' => 1});

    # This bot is silent, for now...
    return undef;
}

{
    my $bot = MongoDbBot->new (
                             server => "mother",
                             port => 6667,
                             channels => "#mongo-test",
                             nick => "Rane69",
                             alt_nicks => ["_Rane69", "_Rane69_"],
                             name => "MongoDB FeedBot"
                            );
    $bot->log("Starting bot...");
    $bot->run();
}

sub find_tags {
    
    my ($self, $msg) = @_;
    my @tags = ();

    @tags = ($msg =~ m/$tags_re/g);

    return @tags;
}

sub log {
    my ($self, $m, $lvl) =@_;
    print STDERR ($lvl ? "[$lvl] " : '') . "$m" . ($m =~ m/\\n$/ ? '' : "\n");
}

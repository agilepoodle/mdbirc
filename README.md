MDBIrc
======

Simple experiment with an irc bot, MongoDB and [Perl Dancer](http://perldancer.org/) webframework. 

Irc bot stores all irc messages into MongoDB with tags that are strings that start with a `#` character.

The web server then displays irc messages and creates searchable tags, allowing users to see all messages tagged with same tags. To search a tag, just navigate to /tag/<insert-tag-here> url.

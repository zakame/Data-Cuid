#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Test::More tests => 3;
use Data::Cuid;

sub _count_ok {
    local $_ = shift;
    my ( $cnt, $desc ) = @_;
    cmp_ok tr/0-9a-zA-Z//, '>=', $cnt, $desc;
}

subtest 'basics' => sub {
    plan tests => 6;

    can_ok 'Data::Cuid' => qw(cuid slug);

    my $id = Data::Cuid::cuid;
    ok $id, 'cuid returns a value';
    note $id;

    is $id =~ /^c/, 1, 'cuid starts with "c"';
    _count_ok $id, 24, 'cuid is at least 24 characters';

    my $slug = Data::Cuid::slug;
    ok $slug, 'slug returns a value';
    note $slug;

    _count_ok $slug, 7, 'slug is at least 7 characters';
};

subtest 'package variables' => sub {
    plan tests => 3;

    is $Data::Cuid::size, 4,  'default block size';
    is $Data::Cuid::base, 36, 'default base';
    is $Data::Cuid::cmax, 36**4,
        'default maximum discrete values for safe counter';
};

subtest 'private functions' => sub {
    plan tests => 5;

    ok Data::Cuid::_fingerprint, 'got fingerprint';

    ok Data::Cuid::_random_block, 'got random block';

    ok Data::Cuid::_timestamp, 'got timestamp';

    my $c = Data::Cuid::_safe_counter;
    ok $c, "counter starts at $c";

    Data::Cuid::_safe_counter while ++$c < $Data::Cuid::cmax;
    is Data::Cuid::_safe_counter, 0, 'safe counter rolls back to 0';
};

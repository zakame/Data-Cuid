#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Test::More tests => 4;
use Data::cuid;
use Math::Base36 'decode_base36';

subtest 'basics' => sub {
    plan tests => 6;

    can_ok 'Data::cuid' => qw(cuid slug);

    my $id = Data::cuid::cuid;
    ok $id, 'cuid returns a value';
    note $id;

    {
        local $_ = $id;
        is /^c/, 1, 'cuid starts with "c"';
        cmp_ok tr/0-9a-zA-Z//, '>=', 24, 'cuid is at least 24 characters';
    }

    my $slug = Data::cuid::slug;
    ok $slug, 'slug returns a value';
    note $slug;

    {
        local $_ = $slug;
        cmp_ok tr/0-9a-zA-Z//, '>=', 7, 'slug is at least 7 characters';
    }
};

subtest 'package variables' => sub {
    plan tests => 3;

    is $Data::cuid::size, 4,  'default block size';
    is $Data::cuid::base, 36, 'default base';
    is $Data::cuid::cmax, 36**4,
        'default maximum discrete values for safe counter';
};

subtest 'private functions' => sub {
    plan tests => 5;

    my $fp = Data::cuid::_fingerprint;
    ok decode_base36 $fp, 'fingerprint is base36-encoded';

    my $rb = Data::cuid::_random_block;
    ok decode_base36 $rb, 'random block is base36-encoded';

    my $ts = Data::cuid::_timestamp;
    ok decode_base36 $ts, 'timestamp is base36-encoded';

    my $c = Data::cuid::_safe_counter;
    ok $c, "counter starts at $c";

    Data::cuid::_safe_counter while ++$c < $Data::cuid::cmax;
    is Data::cuid::_safe_counter, 0, 'safe counter rolls back to 0';
};

subtest 'collisions' => sub {
    plan skip_all => 'Testing collisions only upon release'
        unless $ENV{RELEASE_TESTING};

    my $max = 10_000;
    plan tests => $max * 2;

    my $collisionTest = sub {
        my $fn = shift;
        my %ids;

        my $i = 0;
        while ( $i < $max ) {
            my $id = $fn->();

            ok !$ids{$id}, "$id is unique in $i iterations";
            ++$ids{$id};
            ++$i;
        }
    };

    $collisionTest->( \&Data::cuid::cuid );
    $collisionTest->( \&Data::cuid::slug );
};

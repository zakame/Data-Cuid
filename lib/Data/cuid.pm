package Data::cuid;

use strict;
use warnings;

our @EXPORT_OK;

BEGIN {
    use Exporter 'import';
    @EXPORT_OK = qw(cuid slug);
}

use List::Util 'reduce';
use Math::Base36 ':all';
use Sys::Hostname 'hostname';
use Time::HiRes;

our $blockSize      = 4;
our $base           = 36;
our $discreteValues = $base**$blockSize;

our $VERSION = "0.01";

{
    my $c = 0;

    sub _safe_counter {
        $c = $c < $discreteValues ? $c : 0;
        $c++;
    }
}

sub _fingerprint {
    my $padding = 2;
    my $pid = encode_base36 $$, $padding;

    my $hostname = hostname;
    my $hostId = reduce { $a + ord($b) } length($hostname) + $base,
        split // => $hostname;

    join '' => $pid, encode_base36 $hostId, $padding;
}

sub _random_block { encode_base36 rand() * $discreteValues << 0, $blockSize }
sub _timestamp { encode_base36 sprintf '%.0f' => Time::HiRes::time * 1000 }

sub cuid {
    my $str = 'c';

    my $counter = encode_base36 _safe_counter, $blockSize;

    my $fingerprint = _fingerprint;

    my $random = join '' => _random_block, _random_block;

    lc join '' => $str, _timestamp, $counter, $fingerprint, $random;
}

sub slug {
    my $counter = substr encode_base36(_safe_counter), -4;

    my $fingerprint = join '' => substr( _fingerprint, 0, 1 ),
        substr( _fingerprint, -1 );

    my $random = substr _random_block, -2;

    lc join '' => _timestamp, $counter, $fingerprint, $random;
}

1;
__END__

=encoding utf-8

=for stopwords cuid cuids

=head1 NAME

Data::cuid - collision-resistant IDs

=head1 SYNOPSIS

    use Data::cuid qw(cuid slug);

    my $id   = cuid();          # cjfo7v1dz0001gsd19ldqqke33f
    my $slug = slug();          # jfo8l3mm2pl17

=head1 DESCRIPTION

C<Data::cuid> is a port of the cuid JavaScript library for Perl.

Collision-resistant IDs (also known as I<cuids>) are optimized for
horizontal scaling and binary search lookup performance, especially for
web or mobile applications with a need to generate tens or hundreds of
new entities per second across multiple hosts.

C<Data::cuid> does not export any functions by default.

=head1 FUNCTIONS

=head2 cuid

    my $cuid = cuid();

Produce a cuid as described in L<the original JavaScript
implementation|https://github.com/ericelliott/cuid#broken-down>.  This
cuid is safe to use as HTML element IDs, and unique server-side record
lookups.

=head2 slug

    my $slug = slug();

Produce a shorter ID in nearly the same fashion as L</cuid>.  This slug
is good for things like URL slug disambiguation (i.e., C<<
example.com/some-post-title-<slug> >>) but is absolutely not recommended
for database unique IDs.

=head1 SEE ALSO

L<Cuid|http://usecuid.org/>

=head1 LICENSE

The MIT License (MIT)

Copyright (C) Zak B. Elep.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=head1 AUTHOR

Zak B. Elep E<lt>zakame@cpan.orgE<gt>

Original cuid JavaScript library maintained by L<Eric
Elliott|https://ericelliottjs.com>

=cut

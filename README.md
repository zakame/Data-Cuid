
# NAME

Data::cuid - collision-resistant IDs

# SYNOPSIS

    use Data::cuid qw(cuid slug);

    my $id   = cuid();          # cjfo7v1dz0001gsd19ldqqke33f
    my $slug = slug();          # jfo8l3mm2pl17

# DESCRIPTION

Data::cuid is a port of cuid JavaScript library for Perl.

Collision-resistant IDs (also known as _cuids_) are optimized for
horizontal scaling and binary search lookup performance.

# FUNCTIONS

## cuid

    my $cuid = cuid();

Produce a cuid as described in [the original JavaScript
implementation](https://github.com/ericelliott/cuid#broken-down).

## slug

    my $slug = slug();

Produce a shorter ID in nearly the same fashion as ["cuid"](#cuid).

# SEE ALSO

[Cuid](http://usecuid.org/)

# LICENSE

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

# AUTHOR

Zak B. Elep <zakame@cpan.org>

Original cuid JavaScript library maintained by [Eric
Elliott](https://ericelliottjs.com)

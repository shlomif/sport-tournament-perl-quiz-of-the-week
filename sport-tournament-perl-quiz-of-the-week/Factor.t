#!/usr/bin/perl -w

use strict;

use Test::More tests => 7;

use Tournament;

sub serialize
{
    my $array = shift;
    return join("<====>", 
        map { my $pair = $_; join("||||", @$pair) } 
        @{$array}
    );
}

sub arrays_cmp
{
    my $expected = shift;
    my $result = shift;
    return serialize($expected) cmp serialize($result);
}

sub compare_factors
{
    my $n = shift;
    my $expected = shift;
    return arrays_cmp($expected, factor($n));
}

# TEST
ok (!compare_factors(2, [[2,1]]));

# TEST
ok (!compare_factors(3, [[3,1]]));

# TEST
ok (!compare_factors(4, [[2,2]]));

# TEST
ok (!compare_factors(5, [[5,1]]));

# TEST
ok (!compare_factors(6, [[2,1],[3,1]]));

# TEST
ok (!compare_factors(120, [[2,3],[3,1],[5,1]]));

# TEST
ok (!compare_factors(720, [[2,4],[3,2],[5,1]]));


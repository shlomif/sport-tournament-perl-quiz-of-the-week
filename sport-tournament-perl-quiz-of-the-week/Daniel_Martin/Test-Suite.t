#!/usr/bin/perl -w

use strict;

use Test::More tests => 13;

use Tournament;
# do "dtmQ1Y2005.pl";

use TournVerify;

# Tests for verify_correctness
# TEST
ok (!verify_correctness(2, [[1, 0]]));

# TEST
ok (!verify_correctness(4, [[1,0,3,2],[2,3,0,1],[3,2,1,0]]));

# TEST
ok (!verify_correctness(2, allocate_schedule(2)));

# TEST
ok (!verify_correctness(4, allocate_schedule(4)));

# TEST
ok (!verify_correctness(6, allocate_schedule(6)));

# TEST
ok (!verify_correctness(16, allocate_schedule(16)));

# TEST
ok (!verify_correctness(10, allocate_schedule(10)));

# TEST
ok (!verify_correctness(14, allocate_schedule(14)));

# TEST
ok (!verify_correctness(22, allocate_schedule(22)));

# TEST
{
    my $n = 2*3*5;
    ok (!verify_correctness($n, allocate_schedule($n)));
}

# TEST
{
    my $n = 2*3*7;
    ok (!verify_correctness($n, allocate_schedule($n)));
}

# TEST
{
    my $n = 2*3*3;
    ok (!verify_correctness($n, allocate_schedule($n)));
}


{
    my $n = 2*3*5*7;
    # ok (!verify_correctness($n, allocate_schedule($n)));
}

# TEST
{
    my $n = 2*2*3;
    ok (!verify_correctness($n, allocate_schedule($n)));
}


#!/usr/bin/perl -w

use strict;
use warnings;

use Tournament;
use TournVerify;

sub test_n
{
    my $n = shift;
    print STDERR "\$n=$n\n";
    my $verdict = verify_correctness($n, allocate_schedule($n));
    if ($verdict)
    {
        die "Failed for $n.";
    }
}

for my $i (1 .. 1000)
{
    test_n($i*2);
}

1;


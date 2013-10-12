use strict;
use warnings;

sub allocate_schedule
{
    my $n = shift;

    my $m = $n - 1;
    my @ret;
    for my $d (0 .. ($m-1))
    {
        push @ret, 
            [ (map { ($_ == $d) ? $m : ((2*$d-$_) % $m) } (0..($m-1))), $d ];
    }
    return \@ret;
}

1;


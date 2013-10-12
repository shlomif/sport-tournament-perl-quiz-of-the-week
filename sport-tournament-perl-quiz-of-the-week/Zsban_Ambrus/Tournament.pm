use strict;
use warnings;

sub allocate_schedule
{
    my $n = shift;

    my $m = $n - 1;
    my @ret;
    for my $d (0 .. ($m-1))
    {
        my @day = ();
        for my $k (0 .. ($m-1))
        {
            if ($d == $k)
            {
                push @day, $m;
            }
            else
            {
                push @day, ((2*$d-$k) % $m);
            }
        }
        push @day, $d;
        push @ret, [ @day ];
    }
    return \@ret;
}

1;


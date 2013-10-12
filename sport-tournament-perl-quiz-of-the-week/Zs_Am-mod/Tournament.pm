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
        push @day, ($d+1);
        for my $k (1 .. $m)
        {
            if ($k == ($d+1))
            {
                push @day, 0;
            }
            else
            {
                push @day, (1 + (2*$d+1-$k) % ($m));
            }
        }
        push @ret, [ @day ];
    }
    return \@ret;
}

1;



use strict;
use warnings;

sub gcd
{
    my $n = shift;
    my $m = shift;
    my $remainder = $n % $m;
    if ($remainder == 0)
    {
        return $m;
    }
    else
    {
        return gcd($m, $remainder);
    }
}

sub allocate_schedule
{
    my $n = shift;

    my @schedule = ();

    for my $day (0 .. ($n-2))
    {
        my @day_sched = ((0) x $n);
        my $step = $day+1;        
        my $num_offsets = gcd($n, $step);
        
        for my $offset (0 .. ($num_offsets-1))
        {
            my $team = $offset;

            my $do_once = 1;
            while ($do_once || ($team != $offset))
            {
                $do_once = 0;
                my $other_team = ($team + $step) % $n;
                my $next_team = ($other_team + $step) % $n;
                $day_sched[$team] = $other_team;
                $day_sched[$other_team] = $team;
                $team = $next_team;
            }
        }
        push @schedule, \@day_sched;
    }
    return \@schedule;
}

1;


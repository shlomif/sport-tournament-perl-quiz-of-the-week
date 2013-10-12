
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

sub factor
{
    my $n = shift;

    my @ret;
    my $factor = 2;
    my $times = 0;

    my $process_factor = sub {
        if ($times)
        {
            push @ret, [$factor, $times];
        }
        $times = 0;
        $factor++;
    };
    while ($n != 1)
    {
        if (($n % $factor) == 0)
        {
            $n /= $factor;
            $times++;
        }
        else
        {
            $process_factor->();
        }
    }
    $process_factor->();
    return \@ret;
}

sub factor_flat
{
    my $n = shift;
    my $factors = factor($n);
    return [ map { ($_->[0]) x $_->[1] } @$factors ];
}

sub alloc_2_times_p
{
    my $p = shift;

    my $n = 2*$p;

    my @bits_base = ([0,0,1,1],[0,1,0,1],[0,1,1,0]);
    my @alloc = (((0,1) x (($p-1)/2)), 2);

    my @days;

    # First day - split the teams into pairs and compete the teams
    # within each pair.
    push @days, [ map { ($_*2+1, $_*2) } (0 .. ($p-1))];

    # $n-2 days - compete between the pairs.
    for my $step (1 .. (($p-1)/2))
    {
        my %step_place = (map { ((($step * $_) % $p) => $_) } (0 .. ($p-1)));
        # 4 Permutations for each step
        for my $perm (0 .. 3)
        {
            my @d;
            for my $pair_idx (0 .. ($p-1))
            {
                my $perm_parity = 
                    $bits_base[$alloc[$step_place{$pair_idx}]]->[$perm];
                for my $parity (0 .. 1)
                {
                    my $other_pair_idx;
                    if ($perm_parity == $parity)
                    {
                        $other_pair_idx = $pair_idx + $step;
                    }
                    else
                    {
                        $other_pair_idx = $pair_idx - $step;
                    }
                    $other_pair_idx %= $p;
                    my $other_pair_perm_parity =
                        $bits_base[$alloc
                            [$step_place{$other_pair_idx}]
                            ]->[$perm];
                    my $other_team =$other_pair_idx*2 + $other_pair_perm_parity;
                    if ($perm_parity == $parity)
                    {
                        $other_team ^= 1;
                    }
                    push @d, $other_team;
                }
            }
            push @days, [ @d ];
        }
    }
    return \@days;
}

sub allocate_schedule
{
    my $n = shift;

    my $factors = factor($n);

    if ($factors->[0]->[0] != 2)
    {
        die "Cannot create schedule for odd number of teams";
    }
    # Check for 2*p where p is prime.
    if (($factors->[0]->[1] == 1) && 
        (@$factors == 2) &&
        ($factors->[1]->[1] == 1))
    {
        return alloc_2_times_p($factors->[1]->[0]);
    }

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


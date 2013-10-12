
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

sub cyclical_assignment
{
    my %args = (@_);
    my $schedule_ptr = $args{'schedule_ptr'};
    my $day_offset = $args{'day_offset'};
    my $team_offset = $args{'team_offset'};
    my $team_steps = $args{'team_steps'};
    my $team = $args{'team'};
    my $other_team = $args{'other_team'};
    
    for my $offset (0 .. ($team_steps-1))
    {
        my $dir = ($team < $other_team) ? 1 : (-1);
        for my $team_idx (0 .. ($team_steps-1))
        {
            $schedule_ptr->
                [$day_offset+$offset]->
                [$team_offset+$team*$team_steps+$team_idx] =
                ($team_offset + 
                    $other_team*$team_steps+
                    (($team_idx+$dir*$offset)%$team_steps)
                );
        }
    }
}

# Planning:
# Parameters that all the functions of allocation accept:
# schedule_ptr - a pointer to the schedule (a (N-1) * N matrix of cells.
# day_offset - an offset for the days.
# team_offset - an offset for the teams.
# team_steps - a step in the teams, to be filled using cyclical allocation.
sub alloc_2_times_p
{
    my (%args) = (@_);

    my $schedule_ptr = $args{'schedule_ptr'};
    my $day_offset = $args{'day_offset'};
    my $team_offset = $args{'team_offset'};
    my $team_steps = $args{'team_steps'};
    my $p = $args{'p'};

    my $n = 2*$p;

    my @bits_base = ([0,0,1,1],[0,1,0,1],[0,1,1,0]);
    my @alloc = (((0,1) x (($p-1)/2)), 2);

    my $day = 0;
    my $team = 0;
    
    my $assign = sub {
        my ($other_team) = (@_);
        cyclical_assignment(
            'schedule_ptr' => $schedule_ptr,
            'day_offset' => ($day_offset+$day*$team_steps),
            'team_offset' => $team_offset,
            'team_steps' => $team_steps,
            'team' => $team,
            'other_team' => $other_team,
        );
        # $schedule_ptr->[$day_offset+$day]->[$team_offset+$team] = $other_team;
        $team++;
    };
    
    my $next_day = sub {
        $day++;
        $team = 0;
    };

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
                    my $other_team =
                        $other_pair_idx*2 + $other_pair_perm_parity;
                    if ($perm_parity == $parity)
                    {
                        $other_team ^= 1;
                    }
                    $assign->($other_team);
                }
            }
            $next_day->();
        }
    }
}

sub allocate_schedule_helper
{
    my (%args) = (@_);

    my $n = $args{'n'};
    my $schedule_ptr = $args{'schedule_ptr'};
    my $day_offset = $args{'day_offset'};
    my $team_offset = $args{'team_offset'};

    my $factors = factor($n);

    if ($factors->[0]->[0] != 2)
    {
        die "Cannot create schedule for odd number of teams";
    }
    if ((@$factors == 1) && ($factors->[0]->[1] == 1))
    {
        $schedule_ptr->[$day_offset]->[$team_offset] = $team_offset+1;
        $schedule_ptr->[$day_offset]->[$team_offset+1] = $team_offset;
        return;
    }
    # Check for 2*p where p is prime.
    {
        my $power_of_2 = ((@$factors) == 1);
        my $p = $power_of_2 ? 2 : $factors->[1]->[0];
        
        my $sub_tournaments_size = $n / $p;
        for my $i (0 .. ($p-1))
        {
            allocate_schedule_helper(
                'schedule_ptr' => $schedule_ptr,
                'n' => $sub_tournaments_size,
                'day_offset' => $day_offset,
                'team_offset' => $team_offset+($sub_tournaments_size * $i),
            );
        }
        my $new_day_offset = $day_offset + $sub_tournaments_size - 1;
        if ($power_of_2)
        {
            cyclical_assignment(
                'schedule_ptr' => $schedule_ptr,
                'day_offset' => $new_day_offset,
                'team_offset' => $team_offset,
                'team_steps' => $sub_tournaments_size,
                'team' => 0,
                'other_team' => 1,
            );
            cyclical_assignment(
                'schedule_ptr' => $schedule_ptr,
                'day_offset' => $new_day_offset,
                'team_offset' => $team_offset,
                'team_steps' => $sub_tournaments_size,
                'team' => 1,
                'other_team' => 0,
            );
            
        }
        else
        {
            alloc_2_times_p(
                'p' => $p,
                'schedule_ptr' => $schedule_ptr,
                'day_offset' => $new_day_offset,
                'team_offset' => $team_offset,
                'team_steps' => ($n / (2*$p)),
            );
        }
        return;
    }
}

sub allocate_schedule
{
    my $n = shift;
    my $sched = [ map { [(-1) x $n] } (1 .. ($n-1)) ];
    allocate_schedule_helper(
        'schedule_ptr' => $sched,
        'n' => $n,
        'day_offset' => 0,
        'team_offset' => 0,
    );
    return $sched;
}

1;


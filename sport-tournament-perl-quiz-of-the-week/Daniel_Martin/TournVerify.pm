use strict;
use warnings;

sub verify_correctness
{
    my $n     = shift;
    my $sched = shift;

    my $who_against_who = [ map { [ (0) x $n ] } ( 1 .. $n ) ];

    my $day;
    for $day ( 0 .. ( $n - 2 ) )
    {
        my $day_sched = $sched->[$day];
        for my $team ( 0 .. ( $n - 1 ) )
        {
            my $other_team = $day_sched->[$team];
            if ( $other_team == $team )
            {
                print STDERR "Day $day Team $team competes against itself.\n";
                return 1;
            }
            if ( ( $other_team < 0 ) || ( $other_team >= $n ) )
            {
                print STDERR "Day $day Team $team\'s opponent out of range.";
                return 1;
            }
            if ( $day_sched->[$other_team] != $team )
            {
                print STDERR "Day $day Team $team opponent is not itself\n";
                return 1;
            }
            if ( ++$who_against_who->[$team]->[$other_team] > 2 )
            {
                print STDERR
                    "Teams $team, $other_team team played more than once\n";
                return 1;
            }
            if ( ++$who_against_who->[$other_team]->[$team] > 2 )
            {
                print STDERR
                    "Teams $team, $other_team team played more than once\n";
                return 1;
            }
        }
    }
    for my $team ( 0 .. ( $n - 1 ) )
    {
        for my $other_team ( 0 .. ( $n - 1 ) )
        {
            if ( $who_against_who->[$team]->[$other_team] !=
                ( ( $team == $other_team ) ? 0 : 2 ) )
            {
                print STDERR "w_a_w[$team][$other_team] is wrong.\n";
                return 1;
            }
        }
    }
    return 0;
}

1;


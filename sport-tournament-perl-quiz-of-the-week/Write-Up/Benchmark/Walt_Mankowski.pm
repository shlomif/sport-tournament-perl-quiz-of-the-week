sub allocate_schedule
{
    my $n = shift;
    ++$n if $n % 2;    # add ghost player

    my @teams = ( 0 .. $n - 1 );
    my @sched;
    for ( 1 .. $n - 1 )
    {
        my @round;
        for my $j ( 0 .. $n - 1 )
        {
            $round[ $teams[$j] ] = $teams[ -( $j + 1 ) ];
        }
        push @sched, \@round;
        unshift @teams, splice @teams, -2, 1;
    }
    return \@sched;
}

1;


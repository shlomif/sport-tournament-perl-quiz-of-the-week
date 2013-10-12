sub allocate_schedule {
   my $n = shift;
   return undef unless( defined $n && $n >= 2 && $n % 2 == 0 );

   my $stadium = 1;
   my @nears   = (2 .. ($n/2));
   my @fars    = reverse(($n/2 + 1) .. ($n-1));

   my @result = ();
   $#result = $n - 2;

   foreach my $day (1 .. $n - 1) {
     #print "Day $day\tfars:  ", Dumper(\@fars),  "\tStadium: $stadium\n";
     #print "Day $day\tnears: ", Dumper(\@nears), "\n\n";

     my @today = ();
     $#today = $n - 1;
     $today[0] = $stadium;
     $today[$stadium] = 0;

     foreach my $field (0 .. ($n/2 - 2)) {
       $today[$nears[$field]] = $fars[$field];
       $today[$fars[$field]] = $nears[$field];
     }

     $result[$day - 1] = \@today;

     unshift @fars, $stadium;
     push @nears, (pop @fars);
     $stadium = shift @nears;
   }

   return \@result;
}

1;

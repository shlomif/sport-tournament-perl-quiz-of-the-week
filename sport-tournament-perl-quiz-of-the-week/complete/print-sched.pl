use strict;
use warnings;

use Tournament;

my $s = allocate_schedule(2*2*3); 
print join("\n", 
    map { my $row = $_; join("", map { sprintf("%-4i", $_) } @$row); } @$s);
print "\n";


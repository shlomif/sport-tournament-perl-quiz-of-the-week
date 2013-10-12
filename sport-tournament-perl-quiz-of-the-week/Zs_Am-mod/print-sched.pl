use strict;
use warnings;

use Tournament;

my $n = shift || (2*2*3);
my $s = allocate_schedule($n); 
print join("\n", 
    map { my $row = $_; join("", map { sprintf("%-4i", $_) } @$row); } @$s);
print "\n";


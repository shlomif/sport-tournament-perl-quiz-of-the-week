#!ruby -w
# solution for medium qotw #1
# note: n must be even

def allocate_schedule n;
	(0 ... (m = n - 1)).map { |d|
		(0 ... m).map { |k|
			if d == k; m else (2 * d - k) % m end
		} + [d]
	};
end;

print (allocate_schedule 6)
# test:
#2.step(10, 2) { |n| p allocate_schedule n; };

# my original code giving the day assignments as pairs of teams was:
# perl -we 'for$K(1..5){$M=2*$K+1;for$r(0..2*$K){for$t(1..$K){
#   print(($r+$t)%$M,"-",($r-$t)%$M," ")}print$r,"-",$M,$/}print$/}'

__END__




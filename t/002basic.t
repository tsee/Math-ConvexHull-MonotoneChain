use strict;
use warnings;
use Test::More;
BEGIN {use_ok('Math::ConvexHull::MonotoneChain');}
Math::ConvexHull::MonotoneChain->import('convex_hull');

my @tests = (
  {
    name => 'simple square',
    in => [
      [0, 0],
      [0, 1],
      [1, 0],
      [0.5, 0.5],
      [1, 1],
    ],
    out => [
      [0, 0],
      [1, 0],
      [1, 1],
      [0, 1],
    ],
  }
);

foreach my $test (@tests) {
  my $rv = convex_hull($test->{in});
  is_deeply($rv, $test->{out}, "Test '$test->{name}': output as expected")
    or do {require Data::Dumper; warn Dumper $rv};
}

done_testing;

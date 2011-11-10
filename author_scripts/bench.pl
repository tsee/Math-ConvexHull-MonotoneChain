use strict; use warnings;
use Dumbbench;
use Math::ConvexHull;
use Math::ConvexHull::MonotoneChain;

my $d = Dumbbench->new(
  target_rel_precision => 0.1,
  initial_runs => 10,
  verbosity => 1,
);

my %testsets;
foreach my $n (3, 10, 100, 1000, 10000, 100000, #1000000
) {
  $testsets{$n} =  [
    map {[rand()*1000, rand() * 1000]} 1..$n
  ];
};

my %funcs = (
  graham => \&Math::ConvexHull::convex_hull,
  monotone => \&Math::ConvexHull::MonotoneChain::convex_hull,
);

my %tests;
foreach my $setn (keys %testsets) {
  my $data = $testsets{$setn};
  foreach my $funcn (keys %funcs) {
    my $tname = "${funcn}_$setn";
    my $ch_func = $funcs{$funcn};
    my $func = sub {
      my $rv = $ch_func->($data);
    };
    $tests{$tname} = $func;
  }
}

$d->add_instances(
  map {
    Dumbbench::Instance::PerlSub->new(
      name => $_,
      code => $tests{$_}
    )
  } sort keys %tests
);
$d->run;
print $d->report;

#cmpthese(10.1, \%tests);


use Test::More;
use Etcd::Lock;
use boolean;

my $lu  = new Etcd::Lock( host => 'etcd', key => 'test' . time );

is ($lu->lock, true, "Lock acquired");
is ($lu->unlock, true, "Unlock acquired");

done_testing();

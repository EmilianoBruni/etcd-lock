use Test::More;
use Test::Fork;
use Etcd::Lock;
use boolean;

use DDP;

plan skip_all => 'set TEST_ETCD to enable this test' unless $ENV{TEST_ETCD};

my $lu = new Etcd::Lock( host => $ENV{TEST_ETCD}, key => $$ . time );

is ($lu->ttl, 3600, 'Default TTL');
$lu->ttl(2);
is ($lu->ttl, 2, 'Update TTL');

fork_ok(
    1,
    sub {
        # forked process
        is( $lu->lock, true, "Lock acquired in forked process" );
    }
);

sleep 1;
is( $lu->lock, false, "Lock not acquired in main process" );
sleep 3;
is( $lu->lock, true, "Lock acquired in main process becouse end ttl" );

done_testing();
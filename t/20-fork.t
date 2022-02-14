use Test::More;
use Test::Fork;
use Etcd::Lock;
use boolean;

my $lu  = new Etcd::Lock( host => 'etcd', key => 'test' . time );

fork_ok(
    2,
    sub {
        # forked process
        is( $lu->lock, true, "Lock acquired in forked process" );
        sleep 1;
        is( $lu->unlock, true, "Unlock in forked process" );
    }
);

sleep 1;
is( $lu->lock, false, "Lock not acquired in main process" );
sleep 1;
is( $lu->lock, true, "Lock acquired in main process" );

done_testing();

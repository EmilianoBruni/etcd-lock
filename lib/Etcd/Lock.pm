package Etcd::Lock;

use strict;
use warnings;

use Net::Etcd;
use boolean;

sub new {
    my ( $c, $a ) = @_;
    my $b = {};
    $b->{etcd} = Net::Etcd->new( { host => $a->{host} } );
    foreach qw(host, key) {
        $b->{$_} = $a->{$_};
    }
    return bless $b, $c;
}

sub lock () {
    my $s = shift;
    return $s->_lock_unlock( true );
}

sub unlock () {
    my $s = shift;;
    return $s->_lock_unlock( false );
}

sub _lock_unlock ( ) {
    my $s = shift;
    my $nval = shift;
    my $k = $s->{key};

    my $val = $s->etcd->range( { key => $k } )->get_value;
    return $val unless defined $nval;
    return false if defined $val && $val eq $nval;
    $nval
      ? $s->etcd->put( { key => $k, value => $nval } )
      : $s->etcd->deleterange( { key => $k } );
    return true;
}

1;

__END__

# ABSTRACT: Lock based on etcd

=pod

=encoding UTF-8

=begin :badge

=begin html

<p>
    <a href="https://github.com/emilianobruni/etcd-lock/actions/workflows/test.yml">
        <img alt="github workflow tests" src="https://github.com/emilianobruni/etcd-lock/actions/workflows/test.yml/badge.svg">
    </a>
    <img alt="Top language: " src="https://img.shields.io/github/languages/top/emilianobruni/etcd-lock">
    <img alt="github last commit" src="https://img.shields.io/github/last-commit/emilianobruni/etcd-lock">
</p>

=end html

=end :badge

=head1 SYNOPSIS

  use Etcd::Lock

  my $etcdLock = Etcd::Lock->new(host => 'host.name.com', key => 'lock_key');


=head1 DESCRIPTION

Etcd::Lock is a lock based on etcd

=head1 BUGS/CONTRIBUTING

Please report any bugs through the web interface at L<https://github.com/EmilianoBruni/etcd-lock/issues>

If you want to contribute changes or otherwise involve yourself in development, feel free to fork the Git repository from
L<https://github.com/EmilianoBruni/etcd-lock/>.

=head1 SUPPORT

You can find this documentation with the perldoc command too.

    perldoc etcd-lock

=cut

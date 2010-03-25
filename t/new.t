#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok('Scope::Guard') };

my $i = 1;

sub handler {
    ok($i++ == 3, 'handler invoked on exception');
}

{
    my $guard = Scope::Guard->new(sub { ok($i++ == 1, 'handler invoked at scope end') });
}

sub {
    my $handler = sub { ok($i++ == 2, 'handler invoked on return') };
    my $guard = Scope::Guard->new($handler);
    return;
}->();

eval {
    my $guard = Scope::Guard->new(\&handler);
    my $j = 0;
    my $k = $j / $j;
};

like($@, qr{^Illegal division by zero}, 'exception was raised');

{
    my $guard = Scope::Guard->new(sub { ++$i });
    $guard->dismiss();
}

ok($i++ == 4, 'dismiss() disables handler');

{
    my $guard = Scope::Guard->new(sub { ++$i });
    $guard->dismiss(1);
}

ok($i++ == 5, 'dismiss(1) disables handler');

{
    my $guard = Scope::Guard->new(sub { ok($i++ == 6, 'dismiss(0) enables handler') });
    $guard->dismiss();
    $guard->dismiss(0);
}

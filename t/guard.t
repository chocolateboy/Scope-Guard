#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok('Scope::Guard', 'guard') };

my $i = 1;

{
    guard { ok($i++ == 1, 'handler invoked at scope end') };
}

sub {
    guard { ok($i++ == 2, 'handler invoked on return') };
    return;
}->();

eval {
    guard { ok($i++ == 3, 'handler invoked on exception') };
    my $j = 0;
    my $k = $j / $j;
};

like($@, qr{^Illegal division by zero}, 'exception was raised');

{
    my $guard = guard { ++$i };
    $guard->dismiss();
}

ok($i++ == 4, 'dismiss() disables handler');

{
    my $guard = guard { ++$i };
    $guard->dismiss(1);
}

ok($i++ == 5, 'dismiss(1) disables handler');

{
    my $guard = guard { ok($i++ == 6, 'dismiss(0) enables handler') };
    $guard->dismiss();
    $guard->dismiss(0);
}

# Scope::Guard

[![Build Status](https://github.com/chocolateboy/Scope-Guard/workflows/test/badge.svg)](https://github.com/chocolateboy/Scope-Guard/actions?query=workflow%3Atest)
[![CPAN Version](https://badge.fury.io/pl/Scope-Guard.svg)](https://badge.fury.io/pl/Scope-Guard)

<!-- toc -->

- [NAME](#name)
- [SYNOPSIS](#synopsis)
- [DESCRIPTION](#description)
- [METHODS](#methods)
  - [new](#new)
  - [dismiss](#dismiss)
- [EXPORTS](#exports)
  - [guard](#guard)
  - [scope_guard](#scope_guard)
- [VERSION](#version)
- [SEE ALSO](#see-also)
- [AUTHOR](#author)
- [COPYRIGHT AND LICENSE](#copyright-and-license)

<!-- tocstop -->

# NAME

Scope::Guard - lexically-scoped resource management

# SYNOPSIS

```perl
my $guard = guard { ... };

  # or

my $guard = scope_guard \&handler;

  # or

my $guard = Scope::Guard->new(sub { ... });

$guard->dismiss(); # disable the handler
```

# DESCRIPTION

This module provides a convenient way to perform cleanup or other forms of resource
management at the end of a scope. It is particularly useful when dealing with exceptions:
the `Scope::Guard` constructor takes a reference to a subroutine that is guaranteed to
be called even if the thread of execution is aborted prematurely. This effectively allows
lexically-scoped "promises" to be made that are automatically honoured by perl's garbage
collector.

For more information, see: https://www.drdobbs.com/cpp/184403758

# METHODS

## new

```perl
my $guard = Scope::Guard->new(sub { ... });

  # or

my $guard = Scope::Guard->new(\&handler);
```

The `new` method creates a new `Scope::Guard` object which calls the supplied handler when its `DESTROY` method is
called, typically at the end of the scope.

## dismiss

```perl
$guard->dismiss();

  # or

$guard->dismiss(1);
```

`dismiss` detaches the handler from the `Scope::Guard` object. This revokes the "promise" to call the
handler when the object is destroyed.

The handler can be re-enabled by calling:

```perl
$guard->dismiss(0);
```

# EXPORTS

## guard

`guard` takes a block and returns a new `Scope::Guard` object. It can be used
as a shorthand for:

```perl
Scope::Guard->new(...)
```

e.g.

```perl
my $guard = guard { ... };
```

Note: calling `guard` anonymously, i.e. in void context, will raise an exception.
This is because anonymous guards are destroyed **immediately**
(rather than at the end of the scope), which is unlikely to be the desired behaviour.

## scope_guard

`scope_guard` is the same as `guard`, but it takes a code ref rather than a block.
e.g.

```perl
my $guard = scope_guard \&handler;
```

or:

```perl
my $guard = scope_guard sub { ... };
```

or:

```perl
my $guard = scope_guard $handler;
```

As with `guard`, calling `scope_guard` in void context will raise an exception.

# VERSION

0.21

# SEE ALSO

- [B::Hooks::EndOfScope](https://metacpan.org/pod/B::Hooks::EndOfScope)
- [End](https://metacpan.org/pod/End)
- [Guard](https://metacpan.org/pod/Guard)
- [Hook::Scope](https://metacpan.org/pod/Hook::Scope)
- [Object::Destroyer](https://metacpan.org/pod/Object::Destroyer)
- [Perl::AtEndOfScope](https://metacpan.org/pod/Perl::AtEndOfScope)
- [ReleaseAction](https://metacpan.org/pod/ReleaseAction)
- [Scope::local\_OnExit](https://metacpan.org/pod/Scope::local_OnExit)
- [Scope::OnExit](https://metacpan.org/pod/Scope::OnExit)
- [Sub::ScopeFinalizer](https://metacpan.org/pod/Sub::ScopeFinalizer)
- [Value::Canary](https://metacpan.org/pod/Value::Canary)

# AUTHOR

[chocolateboy](mailto:chocolate@cpan.org)

# COPYRIGHT AND LICENSE

Copyright © 2005-2021 by chocolateboy.

This is free software; you can redistribute it and/or modify it under the terms of the
[Artistic License 2.0](https://www.opensource.org/licenses/artistic-license-2.0.php).

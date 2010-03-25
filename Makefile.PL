use 5.006001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Scope::Guard',
    VERSION_FROM      => 'lib/Scope/Guard.pm', # finds $VERSION
    PREREQ_PM         => {
        'Test::More'  => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Scope/Guard.pm', # retrieve abstract from module
       AUTHOR         => 'chocolateboy <chocolate@cpan.org>') : ()),
);

use Test::More;

BEGIN {
  eval { require Sub::Name }
    or plan skip_all => "Test requires Sub::Name";

  eval { require Sub::Identify }
    or plan skip_all => "Test requires Sub::Identify";
}


BEGIN {
  # shut up the debugger
  $ENV{PERLDB_OPTS} = 'NonStop';

  # work aroud the regex + P::S::XS buggery on
  # < 5.8.6
  require Package::Stash;
}

BEGIN {

#line 1
#!/usr/bin/perl -d
#line 10

}

{
    package Foo;

    BEGIN { *baz = sub { 42 } }
    sub foo { 22 }

    use namespace::clean;

    sub bar {
        ::is(baz(), 42);
        ::is(foo(), 22);
    }
}

ok( !Foo->can("foo"), "foo cleaned up" );
ok( !Foo->can("baz"), "baz cleaned up" );

Foo->bar();

done_testing;

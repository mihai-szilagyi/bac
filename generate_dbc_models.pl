#!/usr/bin/perl -w
use strict;
use warnings;
use DBIx::Class::Schema::Loader qw/ make_schema_at rescan /;

make_schema_at(
	'Schema',
	{ debug => 1,
	  dump_directory => './',
	},
	[ 'dbi:mysql:students:127.0.0.1', 'root', 'root',
# { loader_class => 'MyLoader' } # optionally
	],
);


package Model;

use Schema;

sub save{
	my ($self, $data ) = @_;	
	my $schema = Schema->connect(
	    'dbi:mysql:students:127.0.0.1',
	    'root',
	    'root',
	    { AutoCommit => 1 },
	  );
}

1;
package Model;

use Schema;

use Moose;
has 'schema' => (is => 'ro', 
    default => sub {return Schema->connect(
        'dbi:mysql:students:127.0.0.1',
        'root',
        'root',
        { 
            AutoCommit => 1,
            mysql_enable_utf8 => 1, },
      );
    });

sub save{
    my ($self, $data, $county, $county_id ) = @_;
    my $schema = $self->schema;

    foreach my $student(@$data){
        $student->{school} =~ s/^\s+|\s+$//g ;
    
        my $school = $schema->resultset('School')->find_or_create(
                {
                    name => $student->{school},
                    county => $county,
                    county_id => $county_id
                },
            );
        
        my $profile = $schema->resultset('Profile')->find_or_create({name => $student->{speciality}});
        
        my $school_has_profile = $schema->resultset('SchoolHasProfile')->find_or_create(
                { 
                    school_id => $school->id,
                    profile_id => $profile->id
                });
        my $stud = $schema->resultset('Student')->find_or_create(
            {
                name => $student->{name},
                local_rank => $student->{local_rank},
                global_rank => $student->{global_rank},
                school => $school->id,
                profile => $profile->id,
                form_of_study => $student->{form},
                is_previous => $student->{is_previous},
                media => $student->{media}
            }
        ); 
    }

}

1;
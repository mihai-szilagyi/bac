use utf8;
package Schema::Result::Student;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Student

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<student>

=cut

__PACKAGE__->table("student");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 local_rank

  data_type: 'integer'
  is_nullable: 1

=head2 global_rank

  data_type: 'integer'
  is_nullable: 1

=head2 school

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 profile

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 form_of_study

  data_type: 'varchar'
  is_nullable: 1
  size: 6

=head2 is_previous

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 media

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "local_rank",
  { data_type => "integer", is_nullable => 1 },
  "global_rank",
  { data_type => "integer", is_nullable => 1 },
  "school",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "profile",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "form_of_study",
  { data_type => "varchar", is_nullable => 1, size => 6 },
  "is_previous",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "media",
  { data_type => "double precision", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 grades

Type: has_many

Related object: L<Schema::Result::Grade>

=cut

__PACKAGE__->has_many(
  "grades",
  "Schema::Result::Grade",
  { "foreign.student_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 school_has_profile

Type: belongs_to

Related object: L<Schema::Result::SchoolHasProfile>

=cut

__PACKAGE__->belongs_to(
  "school_has_profile",
  "Schema::Result::SchoolHasProfile",
  { profile_id => "profile", school_id => "school" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-18 15:45:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tDgZECiIPQVaZGNgoEHDjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

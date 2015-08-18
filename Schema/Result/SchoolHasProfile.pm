use utf8;
package Schema::Result::SchoolHasProfile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::SchoolHasProfile

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<school_has_profile>

=cut

__PACKAGE__->table("school_has_profile");

=head1 ACCESSORS

=head2 school_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 profile_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "school_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "profile_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</school_id>

=item * L</profile_id>

=back

=cut

__PACKAGE__->set_primary_key("school_id", "profile_id");

=head1 RELATIONS

=head2 profile

Type: belongs_to

Related object: L<Schema::Result::Profile>

=cut

__PACKAGE__->belongs_to(
  "profile",
  "Schema::Result::Profile",
  { id => "profile_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 school

Type: belongs_to

Related object: L<Schema::Result::School>

=cut

__PACKAGE__->belongs_to(
  "school",
  "Schema::Result::School",
  { id => "school_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 students

Type: has_many

Related object: L<Schema::Result::Student>

=cut

__PACKAGE__->has_many(
  "students",
  "Schema::Result::Student",
  {
    "foreign.profile" => "self.profile_id",
    "foreign.school"  => "self.school_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-18 15:45:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4ioiY/rGOeQ4Aeo/DzfpDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

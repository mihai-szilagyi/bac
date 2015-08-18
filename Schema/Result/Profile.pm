use utf8;
package Schema::Result::Profile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Profile

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<profile>

=cut

__PACKAGE__->table("profile");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 450

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 450 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 school_has_profiles

Type: has_many

Related object: L<Schema::Result::SchoolHasProfile>

=cut

__PACKAGE__->has_many(
  "school_has_profiles",
  "Schema::Result::SchoolHasProfile",
  { "foreign.profile_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 schools

Type: many_to_many

Composing rels: L</school_has_profiles> -> school

=cut

__PACKAGE__->many_to_many("schools", "school_has_profiles", "school");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-18 15:45:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4p3Pxo9O0xw+qMMKk5dGHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

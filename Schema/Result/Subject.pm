use utf8;
package Schema::Result::Subject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Subject

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<subject>

=cut

__PACKAGE__->table("subject");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 450

=head2 type

  data_type: 'varchar'
  default_value: 'scris'
  is_nullable: 1
  size: 45

=head2 obs

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 450 },
  "type",
  {
    data_type => "varchar",
    default_value => "scris",
    is_nullable => 1,
    size => 45,
  },
  "obs",
  { data_type => "varchar", is_nullable => 1, size => 45 },
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
  { "foreign.discipline_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-18 15:45:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oXSmii01t4WQexwWhMmPZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package Schema::Result::Grade;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Grade

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<grade>

=cut

__PACKAGE__->table("grade");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 value

  data_type: 'double precision'
  is_nullable: 1

=head2 discipline_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "value",
  { data_type => "double precision", is_nullable => 1 },
  "discipline_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</discipline_id>

=item * L</student_id>

=back

=cut

__PACKAGE__->set_primary_key("id", "discipline_id", "student_id");

=head1 RELATIONS

=head2 discipline

Type: belongs_to

Related object: L<Schema::Result::Subject>

=cut

__PACKAGE__->belongs_to(
  "discipline",
  "Schema::Result::Subject",
  { id => "discipline_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 student

Type: belongs_to

Related object: L<Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "Schema::Result::Student",
  { id => "student_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-18 15:45:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vRybktEwvbnWxDpSU5jCqw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

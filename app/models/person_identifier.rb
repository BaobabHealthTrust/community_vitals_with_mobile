class PersonIdentifier < ActiveRecord::Base
	set_table_name "person_identifier"
	set_primary_key "person_identifier_id"

  belongs_to :person
  has_one :type, :class_name => :person_identifier_type

end
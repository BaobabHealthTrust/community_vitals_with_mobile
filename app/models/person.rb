class Person < ActiveRecord::Base
	set_table_name "person"
	set_primary_key "person_id"

  has_many :outcomes, :class_name => "Outcome", :foreign_key => :person_id
  has_many :identifiers, :class_name => "PersonIdentifier", :foreign_key => :person_id
  has_many :relationships, :class_name => "Relationship", :foreign_key => :person_a_id

end
class Relationship < ActiveRecord::Base
	set_table_name "relationship"
	set_primary_key "relationship_id"

  belongs_to :person
  has_one :type, :class_name => "RelationshipType", :foreign_key => :relationship_type_id
  belongs_to :relative, :class_name => "Person", :foreign_key => :person_b_id

end
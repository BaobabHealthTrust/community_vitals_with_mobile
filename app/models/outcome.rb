class Outcome < ActiveRecord::Base
	set_table_name "outcome"
	set_primary_key "outcome_id"

  belongs_to :person
  has_one :type, :class_name => "OutcomeType", :foreign_key => :outcome_type_id

end
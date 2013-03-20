class OutcomeType < ActiveRecord::Base
	set_table_name "outcome_type"
	set_primary_key "outcome_type_id"

  belongs_to :outcome

end
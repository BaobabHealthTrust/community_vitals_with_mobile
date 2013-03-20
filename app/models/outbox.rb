class Outbox < ActiveRecord::Base
	set_table_name "outbox"
	set_primary_key "outbox_id"

end
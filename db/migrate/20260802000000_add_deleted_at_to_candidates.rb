class AddDeletedAtToCandidates < ActiveRecord::Migration[8.1]
  def change
    add_column :candidates, :deleted_at, :datetime
  end
end

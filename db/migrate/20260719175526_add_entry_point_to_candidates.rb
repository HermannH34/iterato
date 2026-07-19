class AddEntryPointToCandidates < ActiveRecord::Migration[8.1]
  def change
    add_column :candidates, :entry_point, :string, default: "community", null: false
  end
end

class AddSourceToCandidates < ActiveRecord::Migration[8.1]
  def change
    add_column :candidates, :source, :string, default: "website", null: false
  end
end

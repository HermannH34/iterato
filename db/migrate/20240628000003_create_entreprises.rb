class CreateEntreprises < ActiveRecord::Migration[8.0]
  def change
    create_table :entreprises do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.string :desired_profile
      t.text :context
      t.string :experience_level
      t.timestamps
    end
  end
end

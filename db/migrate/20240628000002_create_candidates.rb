class CreateCandidates < ActiveRecord::Migration[8.0]
  def change
    create_table :candidates do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.string :profile_type
      t.string :experience_level
      t.string :linkedin_url
      t.text :cv_data
      t.string :cv_name
      t.timestamps
    end
  end
end

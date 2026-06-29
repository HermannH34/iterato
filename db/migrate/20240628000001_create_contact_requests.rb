class CreateContactRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_requests do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.string :profile_type
      t.text :context
      t.string :experience_level
      t.string :linkedin_url
      t.text :cv_data
      t.string :cv_name
      t.string :form_type, null: false
      t.timestamps
    end
  end
end

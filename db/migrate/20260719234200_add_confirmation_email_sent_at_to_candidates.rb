class AddConfirmationEmailSentAtToCandidates < ActiveRecord::Migration[8.1]
  def change
    add_column :candidates, :confirmation_email_sent_at, :datetime
  end
end

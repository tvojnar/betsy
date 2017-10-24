class ChangeOrderDateSubmittedToDatetime < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :date_submitted, :datetime
  end
end

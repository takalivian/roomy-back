class AddTitleAndRemarksToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :title, :string, null: false
    add_column :reservations, :remarks, :text
  end
end


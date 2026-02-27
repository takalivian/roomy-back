class CreateReservationParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_participants do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reservation_participants, [:reservation_id, :user_id], unique: true, name: "index_reservation_participants_on_reservation_and_user"
  end
end


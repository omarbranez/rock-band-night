class CreateHosts < ActiveRecord::Migration[6.1]
  def change
    create_table :hosts do |t|
      t.integer :user_id
      t.integer :guest_id
      t.boolean :enabled
      t.boolean :locked

      t.timestamps
    end
  end
end

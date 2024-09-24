class CreateUserTable < ActiveRecord::Migration[7.2]
  def change
    create_table :user_tables do |t|
      t.timestamps
    end
  end
end

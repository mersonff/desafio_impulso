# frozen_string_literal: true

class CreateProponents < ActiveRecord::Migration[7.1]
  def change
    create_table(:proponents) do |t|
      t.string(:name)
      t.string(:cpf)
      t.date(:birth_date)
      t.decimal(:salary, scale: 2, precision: 14)
      t.references(:user)
      t.text(:phones)

      t.timestamps
    end
  end
end

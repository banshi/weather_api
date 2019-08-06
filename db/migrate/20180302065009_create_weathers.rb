class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.date "date"
      t.string "temperature"
      t.index ["date"], name: "index_weathers_on_date"
    end
  end
end

class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.string :start
      t.string :end
      t.text :cache
      t.time :delta

      t.timestamps
    end
  end
end

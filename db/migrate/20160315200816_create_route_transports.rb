class CreateRouteTransports < ActiveRecord::Migration[5.0]
  def change
    create_table :route_transports do |t|
      t.string :route_type
      t.integer :duration
      t.integer :price
      t.references :route, foreign_key: true

      t.timestamps
    end
  end
end

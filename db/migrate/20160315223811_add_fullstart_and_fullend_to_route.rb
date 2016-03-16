class AddFullstartAndFullendToRoute < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :full_start, :string
    add_column :routes, :full_end, :string
  end
end

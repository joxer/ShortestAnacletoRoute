class CreateRouteJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :route_jobs do |t|
      t.string :job_id
      t.boolean :result
      t.integer :route_id, true, null: true

      t.timestamps
    end
  end
end

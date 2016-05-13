class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :duration
      t.string :director
      t.string :rating
      t.text :description

      t.timestamps
    end
  end
end

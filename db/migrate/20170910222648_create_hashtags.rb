class CreateHashtags < ActiveRecord::Migration[5.1]
  def change
    create_table :hashtags do |t|
      t.string :title
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end

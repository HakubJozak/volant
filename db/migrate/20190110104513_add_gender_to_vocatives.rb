class AddGenderToVocatives < ActiveRecord::Migration
  def change
    add_column :vocatives, :gender, :string, :limit => 1

    # remove_index "vocatives", [:type, :nominative]
    # add_index "vocatives", [:type, :gender, :nominative], unique: true
  end
end

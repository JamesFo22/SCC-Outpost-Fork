class AddInstructionsToCustomField < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_fields, :hint, :string
  end
end

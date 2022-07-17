Sequel.migration do
  transaction
  up do
    create_table(:fairy, ignore_index_errors: true) do
      primary_key :id
      String :name, text: true, null: false
      String :human_name, text: true
      String :suffix, text: true

      index [:name], name: :fairy_name_key, unique: true
    end
  end
end

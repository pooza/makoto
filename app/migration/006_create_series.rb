Sequel.migration do
  transaction
  up do
    create_table(:series, ignore_index_errors: true) do
      primary_key :id
      String :name, size: 256, null: false

      index [:name], name: :series_name_idx, unique: true
    end
  end
end

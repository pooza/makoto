Sequel.migration do
  transaction
  up do
    create_table(:track, ignore_index_errors: true) do
      primary_key :id
      String :title, text: true
      String :url, text: true
      TrueClass :makoto, default: false, null: false
      String :intro, text: true

      index [:url], name: :track_url_idx, unique: true
    end
  end
end

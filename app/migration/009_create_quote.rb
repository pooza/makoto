Sequel.migration do
  transaction
  up do
    create_table(:quote) do
      primary_key :id
      foreign_key :series_id, :series, null: false, key: [:id], on_delete: :cascade
      foreign_key :form_id, :form, null: false, key: [:id], on_delete: :cascade
      Integer :episode
      String :emotion, size: 16
      TrueClass :exclude, default: false, null: false
      TrueClass :exclude_respond, default: false, null: false
      Integer :priority, null: false
      String :body, text: true, null: false
      String :remark, text: true
    end
  end
end

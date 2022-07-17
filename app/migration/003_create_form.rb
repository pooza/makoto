Sequel.migration do
  transaction
  up do
    create_table(:form, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>64, :null=>false

      index [:name], :name=>:form_name_idx, :unique=>true
    end
  end
end

Sequel.migration do
  transaction
  up do
    create_table(:past_keyword) do
      primary_key :id
      foreign_key :account_id, :account, :null=>false, :key=>[:id], :on_delete=>:cascade
      DateTime :created_at, :null=>false
      String :surface, :size=>64, :null=>false
      String :feature, :size=>16
    end
  end
end

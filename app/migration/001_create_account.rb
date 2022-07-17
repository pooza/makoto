Sequel.migration do
  transaction
  up do
    create_table(:account, :ignore_index_errors=>true) do
      primary_key :id
      String :acct, :size=>64, :null=>false
      Integer :favorability, :default=>0, :null=>false
      String :nickname, :size=>64

      index [:acct], :name=>:account_acct_key, :unique=>true
    end
  end
end

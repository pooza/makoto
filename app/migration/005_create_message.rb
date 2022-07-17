Sequel.migration do
  transaction
  up do
    create_table(:message, :ignore_index_errors=>true) do
      primary_key :id
      String :type, :size=>64, :null=>false
      String :feature, :size=>64
      String :message, :text=>true, :null=>false
      Integer :month
      Integer :day
      String :data

      index [:feature], :name=>:message_feature_idx
      index [:type], :name=>:message_type_idx
    end
  end
end

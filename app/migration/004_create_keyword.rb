Sequel.migration do
  transaction
  up do
    create_table(:keyword, :ignore_index_errors=>true) do
      primary_key :id
      String :type, :size=>64
      String :word, :size=>64

      index [:type, :word], :name=>:keyword_type_word_idx, :unique=>true
    end
  end
end

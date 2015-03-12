Sequel.migration do
  up do
    create_table :products do
      primary_key :id
      String :category
      String :subcategory
      String :name
      String :description
      String :price
      String :image
      String :url
    end
  end

  down do
    drop_table :products
  end
end

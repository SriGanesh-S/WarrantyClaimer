FactoryBot.define do
  factory :invoice do
    purchase_date { "2023-05-24" }
    cust_email { "testcustomer1@gmail.com" }
    product
    customer
  end
end

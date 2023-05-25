FactoryBot.define do
  factory :seller do
    name { "Test Seller " }

    sequence :email do |i|
      "tester#{i}@gmail.com"
     end
    organisation_name { "OG1" }
    designation { "DSG" }
    phone_no { 7654321890 }
    #primary_address_id { "" }
  end
end

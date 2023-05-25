FactoryBot.define do
  factory :customer do
    name { "Test Customer" }
    sequence :email do |i|
      "tester#{i}@gmail.com"
     end
    age {18}
    gender { "Male" }
    phone_no { 9876543210 }
   # primary_address_id { "" }
  end
end

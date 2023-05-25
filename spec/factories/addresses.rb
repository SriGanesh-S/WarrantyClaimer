FactoryBot.define do
  factory :address do
    door_no { "101" }
    street { "My Street" }
    district { "Coimbatore" }
    state { "Tamil Nadu" }
    pin_code { 641016 }
    phone { 9876543210 }

   for_customers
   
   trait :for_customers do
      association :addressable , factory: :customer
   end
   trait :for_sellers do
     association :addressable , factory: :seller
   end

  end
end

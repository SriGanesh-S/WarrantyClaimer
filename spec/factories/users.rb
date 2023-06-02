FactoryBot.define do
  factory :user do
    sequence :email do |i|
     "tester#{i}@gmail.com"
    end
    password { "111111" }
    password_confirmation { "111111" }
    confirmed_at {Time.current}
    
    for_customers

    trait :for_customers do 
       association :userable , factory: :customer
       role{'Customer'}

    end

    trait :for_sellers do 
      association :userable , factory: :seller
      role{'Seller'}

    end




  end
end

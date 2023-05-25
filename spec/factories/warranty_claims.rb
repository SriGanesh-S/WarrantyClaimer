FactoryBot.define do
  factory :warranty_claim do
    problem_description { "Issues of the product" }
    invoice
  end
end

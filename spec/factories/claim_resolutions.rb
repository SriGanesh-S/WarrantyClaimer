FactoryBot.define do
  factory :claim_resolution do
    status { "In Progress" }
    description { "Description about the status" }
    warranty_claim
  end
end

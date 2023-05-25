require 'rails_helper'

RSpec.describe User, type: :model do

  describe "role" do

    before(:each) do
      user.validate
    end

    context "when value is present" do
      let(:user) {build(:user , role: "Customer")}
      it "doesnt throw any error" do
        expect(user.errors).to_not include(:role)
      end
    end

    context "when value is nil" do
      let(:user) {build(:user , role: nil)}
      it "throws error" do
        expect(user.errors).to include(:role)
      end
    end
  end



  describe 'association' do

    context "belongs_to" do
      let!(:user) {create(:user , :for_customers)}
      it "user is customer" do
        expect(user.userable).to be_an_instance_of(Customer)
      end
    end

    context "belongs_to" do
      let!(:user) {create(:user , :for_sellers)}
      it "user is seller" do
        expect(user.userable).to be_an_instance_of(Seller)
      end
    end
  end
  
end

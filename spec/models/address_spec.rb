require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "door_no" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , door_no: "17")}
      it "doesn't throw any error" do
        expect(address.errors).to_not include(:door_no)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , door_no: nil)}
      it "throws error" do
        expect(address.errors).to include(:door_no)
      end
    end

  end

  describe "street" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , street: "East Street")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:street)
      end
    end

    context "when value is nil" do
      let(:address) {build(:address , street: nil)}
      it "throws error" do
        expect(address.errors).to include(:street)
      end
    end
  end


  describe "district" do
    before(:each) do
      address.validate
    end

    context "when value is present" do
      let(:address) {build(:address , district: "Trichy")}
      it "doesn't throw any error" do
        expect(address.errors).to_not include(:district)
      end
    end

    context "when value is not present" do
      let(:address) {build(:address , district: nil)}
      it "throws error" do
        expect(address.errors).to include(:district)
      end
    end

    context "when value is alphabetic" do
      let(:address) {build(:address , district: "Coimbatore")}
      it "doesn't throw any error" do
        expect(address.errors).to_not include(:district)
      end
    end


    context "when value is not alphabetic" do
      let(:address) {build(:address , district: "Cbe243")}
      it "throws error" do
        expect(address.errors).to include(:district)
      end
    end

  end
 
  describe "state" do
    before(:each) do
      address.validate
    end

    context "when value is not present" do
      let(:address) {build(:address , state: nil)}
      it "throws error" do
        expect(address.errors).to include(:state)
      end
    end

    context "when value is valid" do
      let(:address) {build(:address , state: "Tamil Nadu")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:state)
      end
    end

    context "when value is not alphabetic" do
      let(:address) {build(:address , state: "TN123")}
      it "throws error" do
        expect(address.errors).to include(:state)
      end
    end

  end

  describe "pin_code" do
    before(:each) do
      address.validate
    end


    context "when value is not present" do
      let(:address) {build(:address , pin_code: nil)}
      it "cannot be saved" do
        expect(address.save).to be_falsy
      end
    end

    context "when value is non numeric" do
      let(:address) {build(:address , pin_code: "abcdef")}
      it "cannot be saved" do
        expect(address.errors).to include(:pin_code)
      end
    end
    context "when pin code is valid" do
      let(:address) {build(:address , pin_code: 641016)}
      it "doesn't throw any error" do
        expect(address.errors).to_not include(:pin_code)
      end
    end

    context "when length is less than 6 digits" do
      let(:address) {build(:address , pin_code: 634)}
      it "throws error" do
        expect(address.errors).to include(:pin_code)
      end
    end

    context "when length is greater than 6 digits" do
      let(:address) {build(:address , pin_code: 45671234)}
      it "throws error" do
        expect(address.errors).to include(:pin_code)
      end
    end
  end

  describe "phone" do
    before(:each) do
      address.validate
    end
    context "when value is present" do
      let(:address) {build(:address , phone: "9876543210")}
      it "doesn't throw error" do
        expect(address.errors).to_not include(:phone)
      end
    end
    context "when value is nil" do
      let(:address) {build(:address , phone: nil)}
      it "throws error" do
        expect(address.errors).to include(:phone)
      end
    end

    context "when value with valid length is given" do
      let(:address) {build(:address , phone: "9876543210")}
      it "doesnt throw any error" do
        expect(address.errors).to_not include(:phone)
      end
    end

    context "when value with invalid length is given" do
      let(:address) {build(:address , phone: "98765")}
      it "throws error" do
        expect(address.errors).to include(:phone)
      end
    end

    context "when non numberic value is given" do
      let(:address) {build(:address , phone: "abcdefghij")}
      it "throws error" do
        expect(address.errors).to include(:phone)
      end
    end

    context "when numberic value starts with invalid number" do
      let(:address) {build(:address , phone: "1234567890")}
      it "throws error" do
        expect(address.errors).to include(:phone)
      end
    end
  end


  describe 'association' do

    context "belongs_to" do
      let(:user) {create(:user , :for_customers)}
      it "Customer " do
        expect(user.userable).to be_an_instance_of(Customer)
      end
    end

    context "belongs_to" do
      let(:user) {create(:user , :for_sellers)}
      it "driver is true" do
        expect(user.userable).to be_an_instance_of(Seller)
      end
    end



  end


end

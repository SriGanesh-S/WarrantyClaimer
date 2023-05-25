require 'rails_helper'

RSpec.describe Seller, type: :model do

  describe 'association' do
    context 'has_many' do
      let(:seller) { create(:seller) }
      let(:product) { create(:product) }
      it 'product' do
        seller.products << product
        expect(seller.products).to include(product)
      end

    
  
   
      [ :addresses ,:invoices ,:warranty_claims, :claim_resolutions].each do |each|
        it each.to_s.humanize do
           association = Seller.reflect_on_association(each).macro
           expect(association).to be(:has_many)
        end
      end
    
    end 
    context 'has_and_belongs_to_many' do
     
      it ' customers' do
           association = Seller.reflect_on_association(:customers).macro
           expect(association).to be(:has_and_belongs_to_many)
      end

    end
  
  end


  describe "name" do
    before(:each) do
      seller.validate
    end
    context "when value is present" do
      let(:seller) {build(:seller , name: "seller A")}
      it "doesn't throw any error" do
        expect(seller.errors).to_not include(:name)
      end
    end

    context "when value is nil" do
      let(:seller) {build(:seller , name: nil)}
      it "throws error" do
        expect(seller.errors).to include(:name)
      end
    end

    context "when value is valid" do
      let(:seller) {build(:seller , name: "seller")}
      it "doesn't throw any error" do
        expect(seller.errors).to_not include(:name)
      end
    end

    context "when value is invalid" do
      let(:seller) {build(:seller , name: "seller123")}
      it "throws error" do
        expect(seller.errors).to include(:name)
      end
    end
  end







describe "email" do
    before (:each) do
      seller.validate
    end

    context "when value is nil" do
      let(:seller) {build(:seller, email:nil)}
      it 'throws error' do
        expect(seller.errors).to include(:email)
      end
    end

    context "when value is Not Email" do
      let(:seller) {build(:seller, email:"tester123")}
      it 'throws error' do
        expect(seller.errors).to include(:email)
      end
    end

    context "when value is valid" do
      let(:seller) {build(:seller, email:"tester123@gmail.com")}
      it 'Doesn\'t throws error' do
        expect(seller.errors).to_not include(:email)
      end
    end
  end





  describe "phone_no" do
      before(:each) do
        seller.validate
      end
      context "when value is present" do
        let(:seller) {build(:seller , phone_no: "9876543210")}
        it "doesn't throw error" do
          expect(seller.errors).to_not include(:phone_no)
        end
      end
      context "when value is nil" do
        let(:seller) {build(:seller , phone_no: nil)}
        it "throws error" do
          expect(seller.errors).to include(:phone_no)
        end
      end
  
      context "when value with valid length is given" do
        let(:seller) {build(:seller , phone_no: "9876543210")}
        it "doesnt throw any error" do
          expect(seller.errors).to_not include(:phone_no)
        end
      end

      context "when value with invalid length is given" do
        let(:seller) {build(:seller , phone_no: "98765")}
        it "throws error" do
          expect(seller.errors).to include(:phone_no)
        end
      end
  
      context "when non numberic value is given" do
        let(:seller) {build(:seller , phone_no: "abcdefghij")}
        it "throws error" do
          expect(seller.errors).to include(:phone_no)
        end
      end

      context "when numberic value starts with invalid number" do
        let(:seller) {build(:seller , phone_no: "1234567890")}
        it "throws error" do
          expect(seller.errors).to include(:phone_no)
        end
      end
    end
  describe "organisation_name" do
    before(:each) do
      seller.validate
    end

    context "when value is nil" do
      let(:seller) {build(:seller , organisation_name: nil)}
      it "throws error" do
        expect(seller.errors).to include(:organisation_name)
      end
    end
    context "when value is present" do
      let(:seller) {build(:seller , organisation_name: "Hp")}
      it "throws error" do
        expect(seller.errors).to_not include(:organisation_name)
      end
    end
  end
  describe "designation" do
    before(:each) do
      seller.validate
    end

    context "when value is nil" do
      let(:seller) {build(:seller , designation: nil)}
      it "throws error" do
        expect(seller.errors).to include(:designation)
      end
    end
    context "when value is present" do
      let(:seller) {build(:seller , organisation_name: "Hp")}
      it "throws error" do
        expect(seller.errors).to_not include(:designation)
      end
    end
  end


end

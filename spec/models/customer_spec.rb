require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'association' do
    context 'has_many' do
      let!(:customer) { create(:customer) }
      let!(:invoice) { create(:invoice) }
      it 'invoices' do
        customer.invoices << invoice
        expect(customer.invoices).to include(invoice)
      end

    
  
   
      [ :addresses ,:warranty_claims, :claim_resolutions].each do |each|
        it each.to_s.humanize do
           association = Customer.reflect_on_association(each).macro
           expect(association).to be(:has_many)
        end
      end
    
    end 
    context 'has_and_belongs_to_many' do
     
      it ' sellers' do
           association = Customer.reflect_on_association(:sellers).macro
           expect(association).to be(:has_and_belongs_to_many)
      end

    end
  
  end




  describe "name" do
    before(:each) do
      customer.validate
    end
    context "when value is present" do
      let(:customer) {build(:customer , name: "Customer A")}
      it "doesn't throw any error" do
        expect(customer.errors).to_not include(:name)
      end
    end

    context "when value is nil" do
      let(:customer) {build(:customer , name: nil)}
      it "throws error" do
        expect(customer.errors).to include(:name)
      end
    end

    context "when value is valid" do
      let(:customer) {build(:customer , name: "Customer")}
      it "doesn't throw any error" do
        expect(customer.errors).to_not include(:name)
      end
    end

    context "when value is invalid" do
      let(:customer) {build(:customer , name: "Customer123")}
      it "throws error" do
        expect(customer.errors).to include(:name)
      end
    end
  end


  describe 'age' do

    context 'value is less than 5' do
      let(:customer) { build(:customer, age: 1) }

      it 'is not valid' do
        customer.validate
        expect(customer.errors).to include(:age)
      end
    end

    context 'value is greater than 100' do
      let(:customer) { build(:customer, age: 101) }

      it 'is not valid' do
        customer.validate
        expect(customer.errors).to include(:age)
      end
    end

    context 'value is not a number' do
      let(:customer) { build(:customer, age: 'string') }

      it 'is not valid' do
        customer.validate
        expect(customer.errors).to include(:age)
      end
    end

    context 'presence' do
      it 'is valid when age is present' do
        customer = build(:customer, age: 15)
        customer.validate
        expect(customer.errors).not_to include(:age)
      end

      it 'is not valid when age is empty' do
        customer = build(:customer, age: '')
        customer.validate
        expect(customer.errors).to include(:age)
      end
    end
  end

  describe "email" do
    before (:each) do
      customer.validate
    end

    context "when value is nil" do
      let(:customer) {build(:customer, email:nil)}
      it 'throws error' do
        expect(customer.errors).to include(:email)
      end
    end

    context "when value is Not Email" do
      let(:customer) {build(:customer, email:"tester123")}
      it 'throws error' do
        expect(customer.errors).to include(:email)
      end
    end

    context "when value is valid" do
      let(:customer) {build(:customer, email:"tester123@gmail.com")}
      it 'Doesn\'t throws error' do
        expect(customer.errors).to_not include(:email)
      end
    end
 end

  describe "phone_no" do
      before(:each) do
        customer.validate
      end
      context "when value is present" do
        let(:customer) {build(:customer , phone_no: "9876543210")}
        it "doesn't throw error" do
          expect(customer.errors).to_not include(:phone_no)
        end
      end

      context "when value is nil" do
        let(:customer) {build(:customer , phone_no: nil)}
        it "throws error" do
          expect(customer.errors).to include(:phone_no)
        end
      end
  
      context "when value with valid length is given" do
        let(:customer) {build(:customer , phone_no: "9876543210")}
        it "doesnt throw any error" do
          expect(customer.errors).to_not include(:phone_no)
        end
      end

      context "when value with invalid length is given" do
        let(:customer) {build(:customer , phone_no: "98765")}
        it "throws error" do
          expect(customer.errors).to include(:phone_no)
        end
      end
  
      context "when non numberic value is given" do
        let(:customer) {build(:customer , phone_no: "abcdefghij")}
        it "throws error" do
          expect(customer.errors).to include(:phone_no)
        end
      end

      context "when numberic value starts with invalid number" do
        let(:customer) {build(:customer , phone_no: "1234567890")}
        it "throws error" do
          expect(customer.errors).to include(:phone_no)
        end
      end

    end
  


   describe "gender" do
      before (:each) do
        customer.validate
      end
  
      context "when value is nil" do
        let(:customer) {build(:customer, gender:nil)}
        it 'throws error' do
          expect(customer.errors).to include(:gender)
        end
      end
  
      context "when value is Not Alphabetic" do
        let(:customer) {build(:customer, gender:"m123")}
        it 'throws error' do
          expect(customer.errors).to include(:gender)
        end
      end
  
      context "when value is valid" do
        let(:customer) {build(:customer, gender:"Male")}
        it 'Doesn\'t throws error' do
          expect(customer.errors).to_not include(:email)
        end
      end

    end




end

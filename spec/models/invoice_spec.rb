require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'association' do
    # context 'has_many' do
    #   let(:invoice) { create(:invoice) }
    #   let(:invoice) { create(:invoice) }
    #   it 'invoices' do
    #     invoice.invoices << invoice
    #     expect(invoice.invoices).to include(invoice)
    #   end
    # end
    context 'has_one' do
      [ :warranty_claim, :claim_resolution].each do |each|
        it each.to_s.humanize do
           association = Invoice.reflect_on_association(each).macro
           expect(association).to eq(:has_one)
        end
      end
    end

    context 'belongs_to' do
     it 'product' do
      product = create(:product)
      invoice =create(:invoice , product: product)
      expect(invoice.product).to eql(product)
     end

     it 'customer' do
      customer = create(:customer)
      invoice =create(:invoice , customer: customer)
      expect(invoice.customer).to eql(customer)
     end

    end

  end










  describe "purchase_date" do
    before(:each) do
      invoice.validate
    end

    context "when value is nil" do
      let(:invoice) {build(:invoice , purchase_date: nil)}
      it "throws error" do
        expect(invoice.purchase_date).to eq(Date.current)
      end
    end
    context "when value is present" do
      let(:invoice) {build(:invoice , purchase_date: "2023-05-11")}
      it "throws error" do
        expect(invoice.errors).to_not include(:purchase_date)
      end
    end
  

    context "when Purchase Date is in future" do
     let(:invoice) {build(:invoice , purchase_date:"2024-06-01")}
     it "throws error" do
         expect(invoice.save).to be_falsy
      end
    end

    context "when Date is not valid" do
      let(:invoice) {build(:invoice , purchase_date:"202-31-31")}
      it "throws error" do
        expect(invoice.purchase_date).to eq(Date.current)
      end
    end
  end
 



  describe "Customer email" do
    before (:each) do
      invoice.validate
    end

    context "when value is nil" do
      let(:invoice) {build(:invoice, cust_email:nil)}
      it 'throws error' do
        expect(invoice.errors).to include(:cust_email)
      end
    end

    context "when value is Not an Email" do
      let(:invoice) {build(:invoice, cust_email:"tester123")}
      it 'throws error' do
        expect(invoice.errors).to include(:cust_email)
      end
    end

    context "when value is valid" do
      let(:invoice) {build(:invoice, cust_email:"tester123@gmail.com")}
      it 'Doesn\'t throws error' do
        expect(invoice.errors).to_not include(:cust_email)
      end
    end
  end

end

require 'rails_helper'

RSpec.describe Product, type: :model do
  
  describe 'association' do
    context 'has_many' do
      let(:product) { create(:product) }
      let(:invoice) { create(:invoice) }
      it 'invoices' do
        product.invoices << invoice
        expect(product.invoices).to include(invoice)
      end
    end

    context 'belongs_to' do
     it 'seller' do
      seller = create(:seller)
      product =create(:product , seller: seller)
      expect(product.seller).to eql(seller)
     end

    end

  end


  describe "name" do
    before(:each) do
      product.validate
    end

    context "when value is nil" do
      let(:product) {build(:product , name: nil)}
      it "throws error" do
        expect(product.errors).to include(:name)
      end
    end
    context "when value is present" do
      let(:product) {build(:product , name: "Hp zen Book")}
      it "throws error" do
        expect(product.errors).to_not include(:name)
      end
    end
  end

  describe "name" do
    before(:each) do
      product.validate
    end

    context "when value is nil" do
      let(:product) {build(:product , category: nil)}
      it "throws error" do
        expect(product.errors).to include(:category)
      end
    end
    context "when value is present" do
      let(:product) {build(:product , category: "Laptops")}
      it "throws error" do
        expect(product.errors).to_not include(:category)
      end
    end
  end
end

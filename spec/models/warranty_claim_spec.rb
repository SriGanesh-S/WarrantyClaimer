require 'rails_helper'

RSpec.describe WarrantyClaim, type: :model do
  
  describe 'association' do

    context 'belongs_to' do
     it 'Invoice' do
      invoice = create(:invoice)
      warranty_claim =create(:warranty_claim , invoice: invoice)
      expect(warranty_claim.invoice).to eql(invoice)
     end

    end

    context 'has_one' do
      it 'ClaimResolution' do
           association = WarrantyClaim.reflect_on_association(:claim_resolution).macro
           expect(association).to eq(:has_one)
        
      end
    end

  end
  
  
  
  
  
  describe "problem_description" do
    before(:each) do
      warranty_claim.validate
    end

    context "when value is nil" do
      let(:warranty_claim) {build(:warranty_claim , problem_description: nil)}
      it "throws error" do
        expect(warranty_claim.errors).to include(:problem_description)
      end
    end
    context "when value is present" do
      let(:warranty_claim) {build(:warranty_claim , problem_description: "Isssues of the product ")}
      it "throws error" do
        expect(warranty_claim.errors).to_not include(:problem_description)
      end
    end

    context "when value with invalid length is given" do
      let(:warranty_claim) {build(:warranty_claim , problem_description: "issue")}
      it "throws error" do
        expect(warranty_claim.errors).to include(:problem_description)
      end
    end
  end


  describe "destroy dependency" do

    context "when warranty_claim is deleted" do
      let(:warranty_claim) {create(:warranty_claim)}
      let(:claim_resolution) {create(:claim_resolution , warranty_claim_id: warranty_claim_id )}
      before do
        warranty_claim.destroy
      end
      it "Resolution  also deleted" do
       
        expect(ClaimResolution.find_by(warranty_claim_id: warranty_claim.id)).to be(nil)
      end
      end
    end

end

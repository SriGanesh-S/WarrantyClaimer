require 'rails_helper'

RSpec.describe ClaimResolution, type: :model do
  describe "description" do
    before(:each) do
      claim_resolution.validate
    end

    context "when value is nil" do
      let(:claim_resolution) {build(:claim_resolution , description: nil)}
      it "throws error" do
        expect(claim_resolution.errors).to include(:description)
      end
    end
    context "when value is present" do
      let(:claim_resolution) {build(:claim_resolution , description: "our team will validate the claim ")}
      it "throws error" do
        expect(claim_resolution.errors).to_not include(:description)
      end
    end

    context "when value with invalid length is given" do
      let(:claim_resolution) {build(:claim_resolution , description: "aaa")}
       it "throws error" do
        expect(claim_resolution.errors).to include(:description)
       end
      end
  end

  describe "status" do
    before(:each) do
      claim_resolution.validate
    end

    context "when value is nil" do
      let(:claim_resolution) {build(:claim_resolution , status: nil)}
      it "throws error" do
        expect(claim_resolution.errors).to include(:status)
      end
    end
    context "when value is present" do
      let(:claim_resolution) {build(:claim_resolution , status: "Accepted")}
      it "throws error" do
        expect(claim_resolution.errors).to_not include(:status)
      end
    end

  end




  describe 'association' do

    context 'belongs_to' do
     it 'WarrantyClaim' do
      warranty_claim =create(:warranty_claim )
      claim_resolution = create(:claim_resolution ,warranty_claim: warranty_claim)
      expect(claim_resolution.warranty_claim).to eql(warranty_claim)
     end

    end

    context 'has_one' do
      it 'Invoice' do
           association = ClaimResolution.reflect_on_association(:invoice).macro
           expect(association).to eq(:has_one)
        
      end
    end

  end


  describe "callback" do

   
    context "set_resolution_description" do
      let(:warranty_claim) {create(:warranty_claim)}
      let(:claim_resolution ) {build(:claim_resolution , warranty_claim: warranty_claim)}
      it "Assigns default description" do
        claim_resolution.set_resolution_description
        expect(claim_resolution.description).to eq("Our Team will Validate your claim")
      end
    end



end
  
end

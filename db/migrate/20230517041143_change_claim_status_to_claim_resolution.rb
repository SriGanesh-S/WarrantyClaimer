class ChangeClaimStatusToClaimResolution < ActiveRecord::Migration[6.1]
  def change
    rename_table :claim_statuses, :claim_resolutions

  end
end

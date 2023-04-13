module BaidParser
  extend ActiveSupport::Concern

  BaidParseVersion ||= '0.1'

included do

  # {"displayName"=>"Fake Closed Billing Account",
 #"masterBillingAccount"=>"",
 #"name"=>"billingAccounts/01D001-123456-424242",
 #"open"=>false}
  def self.parse_baid_dict(json_atom, opts={})
    #opts_json_file = opts.fetch :json_file, 'JSON file non datur'
    opts_verbose = opts.fetch :verbose, true

    pp json_atom if  opts_verbose

    baid = BillingAccount.new(
      # originals
      :master_billing_account => json_atom.fetch('masterBillingAccount', nil),
      :name => json_atom['name'],
      :display_name => json_atom['displayName'],
      :open => json_atom.fetch(:open, true),
      # derived
      :description => "Imported by parse_baid_dict v.#{BaidParseVersion}",
      :baid => BillingAccount.extractBaidFromName(json_atom['name']), # I could do at initialize.. NAH!
    )
    pp baid
    pp baid.valid?
    baid.save
    baid
  end

end

end

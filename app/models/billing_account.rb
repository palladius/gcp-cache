class BillingAccount < ApplicationRecord

  validates :baid,
      uniqueness: true,
      presence: true,
      # eg 01AAAA-424242-C1EFC0
      # must be UPPERCASE
      format: { with: /\A[A-F0-9]{6}-[A-F0-9]{6}-[A-F0-9]{6}\z/ }

  validates :name,
      uniqueness: true,
      presence: true

      def self.emoji
        # 🤑 $ 💲 ＄ 💵 💰️ BAIDs
          BAID_ICON rescue '💰️'
      end

      #  #"name"=>"billingAccounts/01D001-123456-424242",
      #  =>  => "01D001-123456-424242"
      def self.extractBaidFromName(name)
        name.split('/')[1] # .second
      end

      def to_s()
          "#{baid} - #{display_name}"
      end


    include BaidParser


end

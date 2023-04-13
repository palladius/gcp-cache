module BillingAccountsHelper
  def render_baid(baid)
      (render_valid(baid) +
      link_to("#{BillingAccount.emoji} #{baid.to_s}", baid)
      ).html_safe
      # add parent if ..
  end

end

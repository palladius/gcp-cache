class PagesController < ApplicationController
  def index
  end

  def stats
    @projects = Project.all
    @folders = Folder.all
    @labels = Label.all
    @inventory_items = InventoryItem.all
    @orgs = Folder.where(is_org: true) #.all
    @billing_accounts_count = BillingAccount.all.count
    # Projects: <b><%=@projects.count%></b>
    # folders: <b><%=@folders.count%></b>
    # labels: <b><%=@labels.count%></b>
    # inventory_items: <b><%=@inventory_items.count%></b>
  end
end

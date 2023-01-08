class PagesController < ApplicationController

  def stats
    @projects = Project.all
    @folders = Folder.all
    @labels = Label.all
    @inventory_items = InventoryItem.all
    @orgs = Folder.where(is_org: true) #.all
    # Projects: <b><%=@projects.count%></b>
# folders: <b><%=@folders.count%></b>
# labels: <b><%=@labels.count%></b>
# inventory_items: <b><%=@inventory_items.count%></b>
  end

end

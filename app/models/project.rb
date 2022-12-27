=begin

This is how a project id JSON looks like in one of my gcloud json exports :) (so could be non-exhaustive)

  {
    "createTime": "2016-12-12T18:01:16.489Z",
    "labels": {
      "bug-id": "b33443920",
      "global-colore": "giallo",
      "notes": "this-is-the-central-orgnode-project",
      "prova": "prova12345",
      "type": "orgnode-and-stuff"
    },
    "lifecycleState": "ACTIVE",
    "name": "OrgNode Project for Palladi US",
    "parent": {
      "id": "824879804362",
      "type": "organization"
    },
    "projectId": "orgnode-palladi-us",
    "projectNumber": "704861684515"
  }

 Let's look at this critically:

[RED] TODO:
*    "labels": Array[str,str]: Totally todo
*    "lifecycleState": "ACTIVE", Todo

[YELLOW] Can do with what we have but better re-do:
* "createTime": we could override the created_at, which makes sense. Or makybe we keep it separated.
*    "name": "OrgNode Project for Palladi US",

[GREEN] We have it ok:
*    "parent": DONE
*    "projectId": "orgnode-palladi-us",
*    "projectNumber": "704861684515"

=end

class Project < ApplicationRecord

    validates :project_id,     uniqueness: true, presence: true
    validates :project_number, uniqueness: true

    # alias :baid, :billing_accoung_id
    def baid 
        @billing_accoung_id || 'XXXXXX-XXXXXX-XXXXXX'
    end

    def setParent(parent_folder)
        raise "Unknown Parent! #{parent_folder.class}" unless  parent_folder.is_a?(Folder)
        self.parent_id = parent_folder.folder_id 
        self.organization_id = parent_folder.folder_id # where recurively finding for parent. Wait for acts_as_tree to find it :) 
        self.description = "[debug] Setting parent to #{parent_folder}" 
        puts "* Is this valid? #{self.valid?}"
        self.save!
        # TODO: also set Organization_id
        #self.organization_id = parent_folder.id where recurively finding for parent. Wait for acts_as_tree to find it :) 
    end

    def to_s(verbose=true)
        return self.project_id unless verbose
        "#{project_id} (#{project_number}) # #{baid}"
    end


    def self.class_emoji 
        PROJECT_ICON
    end
end

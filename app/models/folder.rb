=begin
 

JSON representation of folder according to this gcloud command:
  {
    "createTime": "2020-01-22T17:05:33.521Z",
    "displayName": "TF2b - sempronius",
    "lifecycleState": "ACTIVE",
    "name": "folders/802144187596",
    "parent": "folders/93350088776"
  },

=end

class Folder < ApplicationRecord
    extend ActsAsTree::TreeView
    acts_as_tree order: "name"

    # https://guides.rubyonrails.org/active_record_validations.html
    validates :folder_id, uniqueness: true, presence: true
    #validates :name,  presence: true

    # not self.emoji 
    def emoji
        is_org ? ORG_ICON : FOLDER_ICON rescue '?!?'
    end

    def most_representative_name
        return name if name.to_s.length > 0
        return folder_id if folder_id.to_s.length > 0
        return id if id.to_s.length > 0
        return "oid=#{self.object_id}"
    end
   
    def to_s
        "#{self.emoji} #{most_representative_name}" 
    end


=begin
 Final view should look lik this:
 
 🌲 824879804362 # 'palladi.us'
├─ 🍕 da-cicd-tests (882043492617)
├─ 🍕 metarepo (268290255727)
├─ 🍕 xpn-main (398198244705)
├─ 🍕 orgnode-palladi-us (704861684515)
├─ 📂 1054494897637 (Pulumi)
├─ 📂 510416893777 (TFR Terraformed by Ricc)
    ├─ 📂 93350088776 (TF DEV)
        ├─ 📂 723110142384 (TF0b - titius)
        ├─ 📂 454527359325 (TF1 - foo)
        ├─ 📂 1026736501110 (TF1b - caius)
        ├─ 📂 403965627320 (TF2 - bar)
        ├─ 📂 802144187596 (TF2b - sempronius)
        ├─ 📂 986862742068 (TF3 - baz)

=end
    def carlessian_tree_view(depth=0, opts={})
        # options
        opts_also_add_projects = opts.fetch :also_add_projects, false
        opts_debug = opts.fetch :debug, false
        #main

        folder = self
        #raise "This is not a Folder! Instead its a: '#{folder.class}'" unless  folder.is_a?(Folder)

        #main
        # 1. First, the father
        indentation = depth==0 ? '🌲 ' :
            "   " * (depth-1) + ' ├─ 📂 '
        debug_info = opts_debug ? "[L🌊=#{depth}]" : ''
        ret = "#{indentation}#{debug_info}" + folder.most_representative_name + "\n" # .name})", "/orgs/#{folder.id}" ) + "<br/>" # rescue :Err
        # 2. Then, the N children
        children.each do |child_folder|
            ret +=  child_folder.carlessian_tree_view(depth+1, opts)
        end
        ret
    end   

    def self.class_emoji 
        FOLDER_ICON
    end
end

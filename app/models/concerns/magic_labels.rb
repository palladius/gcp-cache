

# def add_labels_if_they_exist

# end


module MagicLabels     
    extend ActiveSupport::Concern

included do
    # def add_labels_if_they_exist(hash)
    #     exit 78
    # end


  def add_labels_if_they_exist(hash, opts={})
    #options
    opts_debug = opts.fetch :debug, false
    opts_verbose = opts.fetch :verbose, false

    #main
    raise "not a hash" unless hash.is_a?(Hash) 
    if hash.key?('labels')
        puts "#{LABEL_ICON} TODO #{self.emoji} Object #{self} #{self.class} has labels! Let's add them!" if opts_debug
        #puts "TODO self=#{self} #{self.class} hash has labels: #{hash['labels']}"
        hash['labels'].each do |k,v|  
            puts k
            l = Label.create(
                :gcp_k => k,
                :gcp_val => v,
                :labellable => self,
            )
            puts("👍 Label created: #{l} for #{self}") if opts_verbose
        end
    else
        puts "[DEB] NO LABELS - continuing" if opts_debug
    end
  end

end #/included

class_methods do
    # def add_labels_if_they_exist(hash)
    #     raise "Wait this is a Class method while I need the instance to attach the label to!"
    # end
end #/class_methods

end
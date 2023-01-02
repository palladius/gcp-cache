

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
        puts "#{LABEL_ICON} #{self.emoji} Object #{self} #{self.class} #{self.id} has labels! Let's add them!" #if opts_debug
        hash['labels'].each do |k,v|  
            l = Label.create(
                :gcp_k => k,
                :gcp_val => v,
                :labellable => self,
                #:labellable_type => self.class,
                #:labellable_id => self.id,
            )
            puts("👍 Label##{l.id} created for #{self}") if opts_verbose
        end
    else
        puts "[DEB] NO LABELS - continuing" if opts_debug
    end
  end

  # This is a method 'inherited' by all GCP Constructs:
  def add_labels(hash_or_array)
    puts "#{self.class.emoji}#{self.class} x=#{hash_or_array} (type: #{hash_or_array.class})"
    case hash_or_array.class.to_s
      when 'Array' 
        # if AoA: 
        hash_or_array.each do |sub_array|
            raise "I need this to be an AoA: #{hash_or_array}" unless hash_or_array.is_a?(Array)
            raise "sub_array needs to have size 2: #{sub_array.size}" unless sub_array.size == 2
            l = Label.create(
                gcp_k: sub_array.first,
                gcp_val: sub_array.second,
                labellable: self,
            )
            puts "🏓A #{self}: Added label #{l}"
        end
        # TODO if mega single flatten Array of 14 strings which are 7 k/v: 
        # see https://stackoverflow.com/questions/4028329/array-to-hash-ruby 
        # use: Hash[ a.each_slice( 2 ).map { |e| e } ]

        #raise "#{self.class.emoji}#{self.class}.add_labels(ARRAY) not implemented yet"
        return true
      when 'Hash'
        hash_or_array.each do |k,val| 
            l = Label.create(
                gcp_k: k,
                gcp_val: val,
                labellable: self,
            )
            puts "🏓H #{self}: Added label #{l}"
        end
        return true 
        #raise "#{self.class.emoji}#{self.class}.add_labels(HASH) not implemented yet"
      else 
        raise "I need a Hash or an Array: not a '#{hash_or_array.class}'"
    end
    raise "#{self.class.emoji}#{self.class}.add_labels(#{hash_or_array}) not implemented yet"
end

end #/included

class_methods do
    # def add_labels_if_they_exist(hash)
    #     raise "Wait this is a Class method while I need the instance to attach the label to!"
    # end
    # def add_labels(hash_or_array)
    #     puts :TODO_FOLDER2
    #     puts "x=#{hash_or_array} (type: #{hash_or_array.class})"
    #     raise "FOLDER.add_labels_if_they_exist() not implemented yet"
    # end
end #/class_methods

end
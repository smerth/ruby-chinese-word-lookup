class Word

  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  attr_accessor :hanzi, :pinyin, :definition
  
  # Not using this method now in favor of file usable below...
  def self.file_exists?
    # class should know if the restaurant file exists
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end
  
  # This is a common structure to return a boolean after checking alot of 
  # conditions, any one of which might fail.
  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end
  
  def self.create_file
    # create the word file
    File.open(@@filepath, 'w') unless file_exists?
    # Check if the file we created is in fact usable...
    return file_usable?
  end
  
  def self.saved_words
    # read the word file
    words = []
    if file_usable?
      file = File.new(@@filepath , 'r')
      file.each_line do |line|
        words << Word.new.import_line(line.chomp)
      end
      file.close
    end
    # return instances of word
    return words
  end

  def self.build_using_questions
    args = {}

    print "Word (汉子): "
    args[:hanzi] = gets.chomp.strip

    print "Pinyin: "
    args[:pinyin] = gets.chomp.strip
    
    print "Definition: "
    args[:definition] = gets.chomp.strip
    
    return self.new(args)
  end

  def initialize(args={})
    @hanzi      = args[:hanzi] || ""
    @pinyin     = args[:pinyin] || ""
    @definition = args[:definition] || ""
  end

  def import_line(line)
    line_array = line.split("\t")
    # this is a slick way to assign each item in a array to a variable
    @hanzi, @pinyin, @definition = line_array
    return self
  end

  def save
    return false unless Word.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@hanzi, @pinyin, @definition].join("\t")}\n"
    end
    return true
  end

end
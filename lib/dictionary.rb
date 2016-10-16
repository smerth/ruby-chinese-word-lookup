require 'word'
require 'support/string_extend'

class Dictionary

  class Config
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions; @@actions; end
  end

  def initialize(path=nil)
    # locate the word text file at path
    Word.filepath = path
    if Word.file_usable?
      puts "\nFound Dictionary file."
    # or create a new file
    elsif Word.create_file
      puts "Created Dictionary file."
    # exit if create fails
    else
      puts "Exiting.\n\n"
      exit!
    end
  end

  def launch!
    introduction
    # action loop
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end
    conclusion
  end
  
  def get_action
    action = nil
    # Keep asking for user input until we get a valid action
    until Dictionary::Config.actions.include?(action)
      puts "Actions: " + Dictionary::Config.actions.join(", ")
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end
  end

  def list(args=[])
    # todo - the sort should be based on some UIDs for HSK levels, etc. (or  by part of speach)
    sort_order = "pinyin" unless ['hanzi', 'pinyin'].include?(sort_order)
    # puts "\nChinese words\n\n".upcase
    put_centered_header("Chinese words")
    words = Word.saved_words

    words.sort! do |w1, w2|
      case sort_order 
      when 'hanzi'
        w1.hanzi <=> w2.hanzi
      when 'pinyin'
        w1.pinyin.downcase <=> w2.pinyin.downcase
      end
    end
    output_word_table(words)
    puts "Sort by hanzi: 'list hanzi'"
    puts "Sort by pinyi: 'list pinyin'" 
    puts "\n\n"
  end

  def find(keyword="")
    put_centered_header("Find a word")
    if keyword
      # get word list from file
      words = Word.saved_words
      # search
      found = words.select do |wrds|
        wrds.hanzi.downcase.include?(keyword.downcase) ||
        wrds.pinyin.downcase.include?(keyword.downcase) ||
        wrds.definition.downcase.include?(keyword.downcase)
      end
      output_word_table(found)
      puts "\n\n"
    else
      puts "Find words by searching with a keyword"
      puts "Examples: 'find 你好' 'find bicycle' 'find 'xue'\n\n"
    end
  end

  def add
    put_centered_header("Add a Word")
    word = Word.build_using_questions
    if word.save
      puts "\nWord Added\n\n"
    else
      puts "\nSave Error: Word not added\n\n"
    end 
  end

  def introduction
    put_centered_header("<<< Welcome to the Chinese Word Finder >>>")
    put_centered_header("<<< by smerth >>>")
    puts "\n"
    puts "This is an interactive chinese-english dictionary to help you find the word you are looking for.\n\n"
  end

  def conclusion
    puts "\n<<< Goodbye and Happy Studying! >>>\n\n\n"
  end

  private

  def put_centered_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_word_table(words=[])
    print " " + "Definition".ljust(30)
    print " " + "Hanzi (PinYin)".ljust(20) + "\n"
    # print " " + "Definition".rjust(6) + "\n"
    puts "-" * 60
    words.each do |wrd|
      line =  " " << wrd.definition.titleize.ljust(30)
      line << " " + wrd.hanzi + "  (" + wrd.pinyin.ljust(0) + ")"
      # line << " " + wrd.hanzi.rjust(6)
      puts line
    end
    puts "No words found" if words.empty?
    puts "-" * 60
  end

end
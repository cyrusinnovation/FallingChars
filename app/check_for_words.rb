class CheckForWords
  def self.dictionary
    return @dictionary if @dictionary
    load_dictionary
  end

  def self.load_dictionary
    @dictionary = {}
    File.new("#{NSBundle.mainBundle.resourcePath}/#{dict_file}").each do |word|
      @dictionary[word.chomp] = true
    end
    @dictionary
  end

  def self.dict_file
    return 'test_words' if RUBYMOTION_ENV == 'test'
    'dict'
  end

  def self.check_for_words largest_possible_word
    all_possible_words(largest_possible_word).each do |possible_word|
      if word? possible_word
        return possible_word
      end
    end
    false
  end

  def self.all_possible_words largest_possible_word
    0.upto(largest_possible_word.size).collect do |adjusted_start|
      largest_possible_word.size.downto(adjusted_start).collect do |adjusted_end|
        largest_possible_word[adjusted_start..adjusted_end]
      end
    end.flatten
  end

  def self.word? possible_word
    CheckForWords.dictionary.has_key? possible_word
  end
end

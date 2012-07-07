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
    'words'      
  end

  def initialize board, x, y
    @board = board
    @x = x
    @y = y
  end

  def check_for_words
    left = find_letter_farthest_to_left
    right = find_letter_farthest_to_right
    
    all_possible_words(left, right).each do |possible_word|
      if word? possible_word
        left.upto(right).each do |pos|
          @board[[pos, @y]].label.runAction(CCBlink.actionWithDuration(1, blinks: 5))
          @board[[pos, @y]].sprite.runAction(CCSequence.actionsWithArray([CCBlink.actionWithDuration(1, blinks: 5), CCCallFuncO.actionWithTarget(self, selector:'remove:', object: pos)]))
          remove(pos) if RUBYMOTION_ENV == 'test'
        end
        return possible_word
      end
    end
    false
  end

  def all_possible_words left, right
    left.upto(right).collect do |adjusted_left|
      right.downto(adjusted_left).collect do |adjusted_right|
        possible_word adjusted_left, adjusted_right
      end
    end.flatten
  end

  def possible_word left, right
    left.upto(right).collect do |pos|
      @board[[pos, @y]].letter
    end.join
  end

  def word? possible_word
    CheckForWords.dictionary.has_key? possible_word
  end

  def remove pos
    @board[[pos, @y]].sprite.removeFromParentAndCleanup(true)
    @board[[pos, @y]].label.removeFromParentAndCleanup(true)
    @board[[pos, @y]] = nil
  end

  def find_letter_farthest_to_left
    @x.downto(0) do |x_pos|
      return (x_pos + 1) if @board[[x_pos, @y]].nil?
      return 0 if x_pos == 0
    end
  end

  def find_letter_farthest_to_right
    @x.upto(9) do |x_pos|
      return (x_pos - 1) if @board[[x_pos, @y]].nil?
      return 9 if x_pos == 9
    end
  end
end

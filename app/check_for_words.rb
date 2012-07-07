class CheckForWords
  

  def self.dictionary
    return @dictionary if @dictionary
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
    x_left = find_letter_farthest_to_left
    x_right = find_letter_farthest_to_right
    
    word = x_left.upto(x_right).collect do |pos|
      @board[[pos, @y]].letter
    end.join

    if CheckForWords.dictionary.has_key? word
      x_left.upto(x_right).each do |pos|
        @board[[pos, @y]].label.runAction(CCBlink.actionWithDuration(1, blinks: 5))
        @board[[pos, @y]].sprite.runAction(CCSequence.actionsWithArray([CCBlink.actionWithDuration(1, blinks: 5), CCCallFuncO.actionWithTarget(self, selector:'remove:', object: pos)]))
      end
      return word
    end
    false
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

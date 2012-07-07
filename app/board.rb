class Board
  attr_accessor :board

  def initialize
    @board = Hash.new(nil)
  end

  def find_word word, around_x, around_y
    largest_word = find_largest_possible_word around_x, around_y
    left_pos = largest_word.index(word) + find_position_farthest_to_left(around_x, around_y)
    right_pos = word.size + left_pos - 1
    
    left_pos.upto(right_pos).collect do |x|
      @board[[x, around_y]]
    end
  end

  def remove_word word, x, y
    letters = find_word word, x, y
    remove_word_animation letters
  end

  def remove_word_animation letters
    letters.each do |letter|
      letter.label.runAction(CCBlink.actionWithDuration(1, blinks: 5))
      letter.sprite.runAction(CCSequence.actionsWithArray([CCBlink.actionWithDuration(1, blinks: 5), CCCallFuncO.actionWithTarget(self, selector:'remove:', object: letter)]))
      remove(letter) if RUBYMOTION_ENV == 'test'
    end
  end

  def remove letter
    letter.sprite.removeFromParentAndCleanup(true)
    letter.label.removeFromParentAndCleanup(true)

    pos = @board.key(letter)
    @board[pos] = nil

    drop_above pos
  end

  def drop_above pos
    x = pos.first
    y = pos.last
    while !@board[[x, y + 1]].nil?
      @board[[x, y]] = @board[[x, y + 1]]
      @board[[x, y + 1]] = nil
      @board[[x, y]].move_to BoardToScreen.point(x, y)
      y += 1
    end
  end

  def find_largest_possible_word x, y
    left = find_position_farthest_to_left x, y
    right = find_position_farthest_to_right x, y

    left.upto(right).collect do |pos|
      @board[[pos, y]].letter
    end.join
  end

  def find_position_farthest_to_left x, y
    x.downto(0) do |x_pos|
      return (x_pos + 1) if @board[[x_pos, y]].nil?
      return 0 if x_pos == 0
    end
  end

  def find_position_farthest_to_right x, y
    x.upto(9) do |x_pos|
      return (x_pos - 1) if @board[[x_pos, y]].nil?
      return 9 if x_pos == 9
    end
  end

end

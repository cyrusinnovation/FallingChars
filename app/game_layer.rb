class GameLayer < CCLayer 
  attr_accessor :board
  attr_accessor :current_letter

  def self.scene
    scene = CCScene.node
    layer = GameLayer.node

    scene.addChild layer, z:1, tag: 1
    scene
  end

  def onEnter
    super
    @frame_tick = 0

    CheckForWords.load_dictionary
    create_random_letters

    create_batch_node

    create_new_letter random_letter

    @board = Board.new
    
    self.isTouchEnabled = true
    schedule 'update'
  end
  def create_batch_node
    CCSpriteFrameCache.sharedSpriteFrameCache.addSpriteFramesWithFile("game_sprites.plist")
    @batch_node = CCSpriteBatchNode.batchNodeWithFile("game_sprites.png")
    addChild(@batch_node)
  end


  def update
    @frame_tick += 1
    @frame_tick = 0 if @frame_tick == 1000000
  end

  def registerWithTouchDispatcher
    CCTouchDispatcher.sharedDispatcher.addTargetedDelegate(self, priority:0, swallowsTouches:true)
  end

  def ccTouchBegan(touch, withEvent:event)
    touch_began convertTouchToNodeSpace(touch)
  end

  def ccTouchMoved(touch, withEvent:event)
    touch_moved convertTouchToNodeSpace(touch)
  end

  def ccTouchEnded(touch, withEvent:event)
    touch_ended convertTouchToNodeSpace(touch)
  end

  def touch_began position
    true
  end

  def touch_moved position
    x = BoardToScreen.x_in_region position.x
    @current_letter.position = CGPoint.new(BoardToScreen.x_pos(x), 400)
  end

  def touch_ended position
    x = BoardToScreen.x_in_region position.x
    drop_letter x
    create_new_letter random_letter
  end

  def drop_letter x
    y = get_first_unused_spot(x)
    @board.board[[x, y]] = @current_letter
    @current_letter.move_to BoardToScreen.point(x, y)

    largest_possible_word = @board.find_largest_possible_word x, y
    found_word = CheckForWords.check_for_words(largest_possible_word)
    @board.remove_word(found_word, x, y) if found_word
  end

  def get_first_unused_spot x
    9.times { |y| return y if @board.board[[x, y]].nil? }
  end

  def create_new_letter letter
    @current_letter = Letter.new(letter)
    @current_letter.position = CGPoint.new(BoardToScreen.x_pos(4), 400)
    @batch_node.addChild @current_letter.sprite
    addChild(@current_letter.label)
  end

  def random_letter
    @random_letters.sample
  end

  def create_random_letters
    # http://en.wikipedia.org/wiki/Letter_frequency#Relative_frequencies_of_letters_in_the_English_language
    @random_letters = Array.new(8, 'a') + Array.new(13, 'e') + Array.new(7, 'i') + Array.new(7, 'o') + Array.new(3, 'u') + 
      Array.new(2, 'b') +  Array.new(3, 'c') +  Array.new(4, 'd') +  Array.new(2, 'f') +  Array.new(2, 'g') +  Array.new(6, 'h') +  Array.new(1, 'j') +  Array.new(1, 'k') +  
      Array.new(4, 'l') +  Array.new(3, 'm') +  Array.new(3, 'n') +  Array.new(2, 'p') +  Array.new(1, 'q') +  Array.new(6, 'r') +  Array.new(6, 's') +  Array.new(9, 't') +  
      Array.new(1, 'v') +  Array.new(2, 'w') +  Array.new(1, 'x') +  Array.new(2, 'y') +  Array.new(1, 'z')

  end

end

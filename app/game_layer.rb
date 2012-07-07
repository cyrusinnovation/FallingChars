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
    (Array.new(5, 'a') + Array.new(5, 'e') + Array.new(5, 'i') + Array.new(5, 'o') + Array.new(5, 'u') + ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']).sample
  end


end

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

    @board = Hash.new(nil)
    
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
    x = x_in_region position.x
    @current_letter.position = CGPoint.new(x_pos(x), 400)
  end

  def touch_ended position
    x = x_in_region position.x
    drop_letter x
    create_new_letter random_letter
  end

  def drop_letter x
    first_unused_spot = get_first_unused_spot(x)
    @board[[x, first_unused_spot]] = @current_letter
    @board[[x, first_unused_spot]].move_to CGPoint.new(x_pos(x), first_unused_spot * region_size + 20)
    CheckForWords.new(@board, x, first_unused_spot).check_for_words
  end

  def get_first_unused_spot x
    9.times { |y| return y if @board[[x, y]].nil? }
  end

  def x_pos x
    region_size * x + 20
  end

  def create_new_letter letter
    @current_letter = Letter.new(letter)
    @current_letter.position = CGPoint.new(x_pos(4), 400)
    @batch_node.addChild @current_letter.sprite
    addChild(@current_letter.label)
  end

  def random_letter
    (Array.new(5, 'a') + Array.new(5, 'e') + Array.new(5, 'i') + Array.new(5, 'o') + Array.new(5, 'u') + ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z']).sample
  end

  def x_in_region x
    region_num = (x / region_size).to_i
    region_num = 9 if region_num > 9
    region_num
  end

  def region_size
    (CCDirector.sharedDirector.winSize.width - 20) / 10
  end
end

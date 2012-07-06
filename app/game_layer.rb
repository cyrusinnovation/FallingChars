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

    @dictionary = {}
    File.new("#{NSBundle.mainBundle.resourcePath}/#{dict_file}").each do |word|
      @dictionary[word.chomp] = true
    end

    CCSpriteFrameCache.sharedSpriteFrameCache.addSpriteFramesWithFile("game_sprites.plist")
    @batch_node = CCSpriteBatchNode.batchNodeWithFile("game_sprites.png")
    addChild(@batch_node)

    create_new_letter random_letter

    @board = Hash.new(nil)
    
    self.isTouchEnabled = true
    schedule 'update'
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
  end

  def touch_ended position
    x = x_in_region position.x
    drop_letter x
    create_new_letter random_letter
  end

  def drop_letter x
    first_unused_spot = get_first_unused_spot(x)
    @board[[x, first_unused_spot]] = @current_letter
    @current_letter.position = CGPoint.new(x_pos(x), first_unused_spot * region_size + 20)

    check_for_words(x, first_unused_spot)
  end

  def check_for_words x, y
    x_left = find_letter_farthest_to_left x, y
    x_right = find_letter_farthest_to_right x, y
    
    word = x_left.upto(x_right).collect do |pos|
      @board[[pos, y]].letter
    end.join
    
    return word if @dictionary.has_key? word
    false
  end

  def find_letter_farthest_to_left x, y
    x.downto(0) do |x_pos|
      return (x_pos + 1) if @board[[x_pos, y]].nil?
      return 0 if x_pos == 0
    end
  end

  def find_letter_farthest_to_right x, y
    x.upto(9) do |x_pos|
      return (x_pos - 1) if @board[[x_pos, y]].nil?
      return 9 if x_pos == 9
    end
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
    ('a'..'z').to_a.sample
  end

  def x_in_region x
    region_num = (x / region_size).to_i
    region_num = 9 if region_num > 9
    region_num
  end

  def region_size
    (CCDirector.sharedDirector.winSize.width - 20) / 10
  end

  def dict_file
    return 'test_words' if RUBYMOTION_ENV == 'test'
    'words'      
  end
end

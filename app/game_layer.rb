class GameLayer < CCLayer 

  def self.scene
    scene = CCScene.node
    layer = GameLayer.node

    scene.addChild layer, z:1, tag: 1
    scene
  end

  def onEnter
    super
    @frame_tick = 0

    CCSpriteFrameCache.sharedSpriteFrameCache.addSpriteFramesWithFile("game_sprites.plist")

    @bullets_batch = CCSpriteBatchNode.batchNodeWithFile("game_sprites.png")
    addChild(@bullets_batch)

    @bullets_batch.addChild CCSprite.spriteWithSpriteFrameName('circle.png')

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
    location = convertTouchToNodeSpace(touch)
    CGRectContainsPoint(@player.sprite.boundingBox, location)
  end

  def ccTouchMoved(touch, withEvent:event)
    location = convertTouchToNodeSpace(touch)
    touch_moved Point.new(location)
  end

  def ccTouchEnded(touch, withEvent:event)
    touch_ended
  end

  def touch_began position
    true
  end

  def touch_moved position
  end

  def touch_ended
  end

end

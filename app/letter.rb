class Letter
  attr_accessor :letter
  attr_accessor :sprite
  attr_accessor :label
  attr_accessor :shadowed_drop
  attr_accessor :shadowed_drop_label

  def initialize letter
    @letter = letter
    @sprite = CCSprite.spriteWithSpriteFrameName('circle.png')
    @shadowed_drop = CCSprite.spriteWithSpriteFrameName('circle.png')
    @shadowed_drop.opacity = 160

    @shadowed_drop_label = create_label
    @shadowed_drop_label.opacity = 180
    @label = create_label
  end

  def create_label
    label = CCLabelTTF.labelWithString(letter, fontName:"Marker Felt", fontSize:24)
    label.color = [230, 20, 20]
    label
  end

  def position
    @sprite.position
  end

  def set_position point, shadowed_point
    @sprite.position = point
    @label.position = point
    @shadowed_drop.position = shadowed_point
    @shadowed_drop_label.position = shadowed_point
  end

  def move_to point
    move = CCMoveTo.actionWithDuration(0.7, position: point)
    moveLabel = CCMoveTo.actionWithDuration(0.7, position: point)
    sprite.runAction move
    label.runAction moveLabel
  end
end

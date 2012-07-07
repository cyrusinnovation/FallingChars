class Letter
  attr_accessor :letter
  attr_accessor :sprite
  attr_accessor :label

  def initialize letter
    @letter = letter
    @sprite = CCSprite.spriteWithSpriteFrameName('circle.png')

    @label = CCLabelTTF.labelWithString(letter, fontName:"Marker Felt", fontSize:24)
    @label.color = [230, 20, 20]
  end

  def position
    @sprite.position
  end

  def position= point
    @sprite.position = point
    @label.position = point
  end
end

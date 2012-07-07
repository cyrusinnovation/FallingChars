class BoardToScreen
  def self.point x, y
    CGPoint.new(x_pos(x), y_pos(y))
  end

  def self.x_pos x
    region_size * x + 20
  end

  def self.y_pos y
    region_size * y + 20
  end

  def self.region_size
    (CCDirector.sharedDirector.winSize.width - 20) / 10
  end

  def self.x_in_region x
    region_num = (x / region_size).to_i
    region_num = 9 if region_num > 9
    region_num
  end
end

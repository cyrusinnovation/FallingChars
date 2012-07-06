def game_layer
  CCDirector.sharedDirector.runningScene.getChildByTag(1)
end

def next_frame
  game_layer.update
end

def move_player move_to
  drag_to(move_to) do |pos|
    game_layer.touch_moved(pos)
  end
end

def touch pos
  @beginTouch = pos
  game_layer.touch_began pos
end

def release_touch pos
  game_layer.touch_ended pos
end

def drag_to pos
  while pos != player.sprite.position
    position = player.sprite.position

    x = closer_point position.x, pos.x
    y = closer_point position.y, pos.y

    yield Point.new(x, y)
  end
end

def closer_point start, to
  if start > to
    start - 1
  elsif start == to
    start
  else
    start + 1
  end
end

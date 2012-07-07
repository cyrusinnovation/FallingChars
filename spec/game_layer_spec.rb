describe GameLayer do
  before do
    @game_layer = GameLayer.scene.getChildByTag(1)
    @game_layer.onEnter
  end


  it "can detect what region a touch is in" do
    @game_layer.x_in_region(10).should == 0
    @game_layer.x_in_region(161).should == 5
    @game_layer.x_in_region(320).should == 9
  end

  it "can drop letters" do
    @game_layer.get_first_unused_spot(0).should == 0
    @game_layer.board.board[[0, 0]] = Letter.new('a')
    @game_layer.get_first_unused_spot(0).should == 1
  end
end

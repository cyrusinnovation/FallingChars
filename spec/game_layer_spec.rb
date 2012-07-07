describe GameLayer do
  before do
    @game_layer = GameLayer.scene.getChildByTag(1)
    @game_layer.onEnter
  end

  it "can drop letters" do
    @game_layer.get_first_unused_spot(0).should == 0
    @game_layer.board.board[[0, 0]] = Letter.new('a')
    @game_layer.get_first_unused_spot(0).should == 1
  end
end

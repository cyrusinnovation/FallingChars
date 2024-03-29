describe "Game" do
 before do
    CCDirector.sharedDirector.replaceScene GameLayer.scene
    CCDirector.sharedDirector.drawScene
  end

  it "can drop a letter on tap release" do
    touch CGPoint.new(10, 10)
    release_touch CGPoint.new(10, 10)
    game_layer.board.board[[0, 0]].should.not == nil
  end

  it "can drop multiple letters" do
    first_letter = drop_letter 0
    second_letter = drop_letter 9

    game_layer.board.board[[0, 0]].should == first_letter
    game_layer.board.board[[9, 0]].should == second_letter
    first_letter.should.not == game_layer.current_letter
  end

  it "can drop letters on top of each other" do
    first_letter = drop_letter 0
    second_letter = drop_letter 0

    game_layer.board.board[[0, 0]].should == first_letter
    game_layer.board.board[[0, 1]].should == second_letter
  end

  it "can recognize and remove words" do
    drop_letter 0, 'c'
    drop_letter 1, 'a'
    drop_letter 2, 't'

    game_layer.board.board[[0, 0]].should == nil
  end

  it "drops letters above removed words" do
    drop_letter 0, 'c'
    dropped = drop_letter 0, 'm'
    drop_letter 1, 'a'
    drop_letter 2, 't'

    game_layer.board.board[[0, 0]].should == dropped
  end
  

  def drop_letter x, new_letter='a'
    letter = game_layer.current_letter
    letter.letter = new_letter
    game_layer.drop_letter x
    game_layer.create_new_letter 'a'
    letter
  end

end

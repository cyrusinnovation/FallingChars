describe CheckForWords do
  before do
    game_layer = GameLayer.scene.getChildByTag(1)
    game_layer.onEnter
    @board = game_layer.board
  end

  it "can check for words" do
    @board[[0, 0]] = Letter.new('c')
    @board[[1, 0]] = Letter.new('a')
    @board[[2, 0]] = Letter.new('t')

    CheckForWords.new(@board, 2, 0).check_for_words.should == 'cat'
  end

  it "can find small words in a sequence" do
    @board[[0, 0]] = Letter.new('d')
    @board[[1, 0]] = Letter.new('c')
    @board[[2, 0]] = Letter.new('a')
    @board[[3, 0]] = Letter.new('t')
    
    CheckForWords.new(@board, 2, 0).check_for_words.should == 'cat'
  end


end

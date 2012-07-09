describe Board do
  it "can find words near a position" do
    board = Board.new()

    board.board[[1, 0]] = Letter.new('a')

    board.board[[2, 0]] = Letter.new('c')
    board.board[[3, 0]] = Letter.new('a')
    board.board[[4, 0]] = Letter.new('t')

    board.board[[5, 0]] = Letter.new('z')

    board.find_word('cat', 3, 0).should == [board.board[[2, 0]], board.board[[3, 0]], board.board[[4, 0]]]
  end

  it "can find both horizontal and vertical words near a position" do
    board = Board.new()


    board.board[[2, 1]] = Letter.new('c')
    board.board[[3, 1]] = Letter.new('a')
    board.board[[4, 1]] = Letter.new('t')

    board.board[[3, 0]] = Letter.new('t')

    board.find_words(['cat', 'at'], 3, 1).should == [[board.board[[2, 0]], board.board[[3, 0]], board.board[[4, 0]]], [board.board[[3, 1]], board.board[[3, 0]]]]
  end
  

end

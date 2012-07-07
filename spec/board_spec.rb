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

end

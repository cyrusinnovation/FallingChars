describe Board do
  it "can find words near a position" do
    board = Board.new()
    board.board[[0, 0]] = Letter.new('c')
    board.board[[1, 0]] = Letter.new('a')
    board.board[[2, 0]] = Letter.new('t')

    board.find_word('cat', 1, 0).should == [board.board[[0, 0]], board.board[[1, 0]], board.board[[2, 0]]]
  end

end

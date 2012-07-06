describe Letter do
 before do
  end

  it "has a letter" do
    letter = Letter.new 'a'
    letter.letter.should == 'a'
  end

end

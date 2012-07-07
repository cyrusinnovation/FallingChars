describe BoardToScreen do
  it "can detect what region a touch is in" do
    BoardToScreen.x_in_region(10).should == 0
    BoardToScreen.x_in_region(161).should == 5
    BoardToScreen.x_in_region(320).should == 9
  end
end

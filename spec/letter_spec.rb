describe Letter do
 before do
  end

  it "has a letter" do
    letter = Letter.new 'a'
    letter.letter.should == 'a'
  end

  it "has a shadowed drop to make dropping more accurate" do
    letter = Letter.new 'a'
    letter.shadowed_drop.should.not == nil
  end

  it "can change the position and change the sprite, label and shadowed" do
    letter = Letter.new 'a'
    point = CGPoint.new(20, 400)
    shadow_point = CGPoint.new(20, 20)
    letter.set_position point, shadow_point
    letter.sprite.position.should == point
    letter.label.position.should == point
    letter.shadowed_drop.position.should == shadow_point
    letter.shadowed_drop_label.position.should == shadow_point
  end

end

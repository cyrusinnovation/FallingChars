describe CheckForWords do
  it "can check for words" do
    CheckForWords.check_for_words('cat').should == 'cat'
  end

  it "can find small words in a sequence" do
    CheckForWords.check_for_words('dcat').should == 'cat'
  end
end

describe 'Bookmark' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Bookmark entity' do
    Bookmark.entity_description.name.should == 'Bookmark'
  end
end

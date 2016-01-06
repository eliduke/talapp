class Episode

  PROPERTIES = [:number, :title, :description, :date, :image_url, :podcast_url]
  PROPERTIES.each { |prop| attr_accessor prop }

  def initialize(json = {})
    json.each do |key, value|
      send("#{key}=", value) if PROPERTIES.include? key.to_sym
    end
  end

  def bookmarked?
    Bookmark.where(:number).eq(self.number).size == 1
  end

end
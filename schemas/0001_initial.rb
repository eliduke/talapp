schema "0001 initial" do

  entity "Bookmark" do
    integer32 :number, optional: true
    string :title, optional: true
    string :published_on, optional: true
    string :summary, optional: true
    string :image_url, optional: true
    string :podcast_url, optional: true
  end

end

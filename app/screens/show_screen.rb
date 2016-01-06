class ShowScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  attr_accessor :episode

  def on_load
    $episode = @episode
  end

  def table_data
    [{
      cells: [{
        cell_class: ShowCell,
        properties: { params: { episode: @episode } },
        selection_style: :none,
      },{
        cell_class: Button,
        properties: { params: { settings: { text: @episode.bookmarked? ? "Bookmarked" : "Bookmark", color: rmq.color.blue } } },
        action: :bookmark,
        arguments: @episode
      },{
        cell_class: Button,
        properties: { params: { settings: { text: "Play Episode", color: rmq.color.red } } },
        action: :play_podcast,
        arguments: @episode.podcast_url
      }]
    }]
  end

  def bookmark(episode)
    if episode.bookmarked?
      bm = Bookmark.where(:number).eq(episode.number).first
      bm.destroy
      if cdq.save
        $notifier.success("Bye bye, Bookmark.")
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    else
      Bookmark.create(number: episode.number, title: episode.title, published_on: episode.date, summary: episode.description, image_url: episode.image_url, podcast_url: episode.podcast_url)
      if cdq.save
        $notifier.success("Episode Bookmarked!")
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    end
  end

  def play_podcast(url)
    BW::Media.play_modal(url)
  end

end

class ShowScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  attr_accessor :episode

  def on_load
  end

  def table_data
    [{
      cells: [{
        cell_class: ShowCell,
        properties: { params: { episode: @episode } },
        selection_style: :none,
      }]
    }]
  end

  def bookmark
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

  def play
    BW::Media.play_modal(episode.podcast_url)
  end

end

class RandomScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  def on_init
    set_tab_bar_item title: "Random", item: icon_image(:awesome, :random, size: 25)
  end

  def on_load
    set_nav_bar_button :right, title: icon_image(:awesome, :refresh, size: 20, color: color.white), action: :refresh
    fetch_data
  end

  def fetch_data
    AFMotion::JSON.get("http://api.thisamericanlife.co/random") do |response|
      if response.success?
        @episode = Episode.new(response.object["podcast"])
        update_table_data
        end_refreshing
      else
        end_refreshing
        app.alert("Oops. Try again.")
      end
    end
  end

  def table_data
    return [] unless @episode
    [{
      cells: [{
        cell_class: ShowCell,
        properties: { params: { episode: @episode } },
        selection_style: :none,
      }]
    }]
  end

  def refresh
    fetch_data
  end

  def bookmark
    if @episode.bookmarked?
      bm = Bookmark.where(:number).eq(@episode.number).first
      bm.destroy
      if cdq.save
        $notifier.success("Bye bye, Bookmark.")
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    else
      Bookmark.create(number: @episode.number, title: @episode.title, published_on: @episode.date, summary: @episode.description, image_url: @episode.image_url, podcast_url: @episode.podcast_url)
      if cdq.save
        $notifier.success("Episode Bookmarked!")
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    end
  end

  def play
    BW::Media.play_modal(@episode.podcast_url)
  end

end

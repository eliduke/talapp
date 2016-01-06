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
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    else
      Bookmark.create(number: episode.number, title: episode.title, published_on: episode.date, summary: episode.description, image_url: episode.image_url, podcast_url: episode.podcast_url)
      if cdq.save
        update_table_data
      else
        $notifier.error("Oops! Try again.")
      end
    end
  end

  def refresh
    fetch_data
  end

  def play_podcast(url)
    BW::Media.play_modal(url)
  end

end

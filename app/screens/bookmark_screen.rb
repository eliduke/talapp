class BookmarkScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  refreshable callback: :fetch_data,
    pull_message: "Pull down to refresh",
    refreshing: "Loading...",
    updated_format: "Last updated at %s",
    updated_time_format: "%l:%M %p"

  def on_init
    set_tab_bar_item title: "Bookmarks", item: icon_image(:awesome, :bookmark, size: 25)
  end

  def on_load
    fetch_data
  end

  def on_appear
    fetch_data
  end

  def fetch_data
    @episodes = []
    Bookmark.all.array.each do |bookmark|
      @episodes << Episode.new(number: bookmark.number, title: bookmark.title, date: bookmark.published_on, description: bookmark.summary, image_url: bookmark.image_url, podcast_url: bookmark.podcast_url)
    end
    update_table_data
    end_refreshing
  end

  def table_data
    return no_bookmarks unless @episodes.size > 0
    [{
      cells: @episodes.reverse.map do |episode|
        {
          cell_class: ListCell,
          properties: { params: { episode: episode } },
          action: :show_episode,
          arguments: episode
        }
      end
    }]
  end

  def no_bookmarks
    [{
      cells: [{
        cell_class: Button,
        properties: { params: { settings: { text: "No Bookmarks", color: rmq.color.medium_gray } } },
        action: :hey_now
      }]
    }]
  end

  def show_episode(episode)
    open ShowScreen.new(nav_bar: true, episode: episode)
  end

  def hey_now
    app.alert("Hey! Watch where you're poking that thing!")
  end

end

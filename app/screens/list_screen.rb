class ListScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  refreshable callback: :fetch_data,
    pull_message: "Pull down to refresh",
    refreshing: "Loading...",
    updated_format: "Last updated at %s",
    updated_time_format: "%l:%M %p"

  def on_init
    set_tab_bar_item title: "Recent", item: icon_image(:awesome, :clock_o, size: 25)
  end

  def on_load
    $notifier.loading(:black)
    fetch_data
  end

  def fetch_data
    AFMotion::JSON.get("http://api.thisamericanlife.co") do |response|
      if response.success?
        @episodes = []
        response.object["podcasts"].each do |episode|
          @episodes << Episode.new(episode)
        end
        update_table_data
        end_refreshing
        $notifier.dismiss
      else
        end_refreshing
        $notifier.dismiss
        app.alert("Oops. Try again.")
      end
    end
  end

  def table_data
    return [] unless @episodes
    [{
      cells: @episodes.map do |episode|
        {
          cell_class: ListCell,
          properties: { params: { episode: episode } },
          action: :show_episode,
          arguments: episode
        }
      end + load_more
    }]
  end

  def load_more
    [{ cell_class: LoadMore, height: 50 }]
  end

  def will_display_cell(cell, index_path)
    cell.backgroundColor = UIColor.clearColor
    if index_path.row >= @episodes.length
      load_more_episodes
    end
  end

  def load_more_episodes
    page = (@episodes.size / 10) + 1
    AFMotion::JSON.get("http://api.thisamericanlife.co?page=#{page}") do |response|
      if response.success?
        response.object["podcasts"].each do |episode|
          @episodes << Episode.new(episode)
          update_table_data
          $notifier.dismiss
        end
      else
        $notifier.dismiss
        app.alert("Oops. Try again.")
      end
    end

  end

  def show_episode(episode)
    open ShowScreen.new(nav_bar: true, episode: episode)
  end

end

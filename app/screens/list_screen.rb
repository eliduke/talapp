class ListScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  refreshable callback: :fetch_data,
    pull_message: "Pull down to refresh",
    refreshing: "Loading...",
    updated_format: "Last updated at %s",
    updated_time_format: "%l:%M %p"

  def on_load
    @episodes = []
    fetch_data
  end

  def fetch_data
    AFMotion::JSON.get("http://api.thisamericanlife.co") do |response|
      if response.success?
        @episodes = []
        response.object["podcasts"].each do |episode|
          @episodes << Episode.new(episode)
          update_table_data
          end_refreshing
        end
      else
        app.alert("Oops. Try again.")
      end
    end
  end

  def table_data
    [{
      cells: @episodes.map do |episode|
        {
          cell_class: ListCell,
          properties: { params: { episode: episode } },
          action: :show_episode,
          arguments: episode
        }
      end
    }]
  end

  def show_episode(episode)
    open ShowScreen.new(nav_bar: true, episode: episode)
  end

  # You don't have to reapply styles to all UIViews, if you want to optimize, another way to do it
  # is tag the views you need to restyle in your stylesheet, then only reapply the tagged views, like so:
  #   def logo(st)
  #     st.frame = {t: 10, w: 200, h: 96}
  #     st.centered = :horizontal
  #     st.image = image.resource('logo')
  #     st.tag(:reapply_style)
  #   end
  #
  # Then in will_animate_rotate
  #   find(:reapply_style).reapply_styles#

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    find.all.reapply_styles
  end
end

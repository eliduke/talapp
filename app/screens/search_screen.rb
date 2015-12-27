class SearchScreen < PM::GroupedTableScreen
  title "This American Life"
  stylesheet SearchScreenStylesheet
  row_height :auto, estimated: 100

  def on_init
    set_tab_bar_item system_item: :search
  end

  def on_load
    @episodes = []
  end

  def on_appear
    find(:search).style do |st|
      st.view.delegate = self
      st.left_view = create!(UIView, :padding).tap { |padding| padding.append(UIView, :box).tap { |box| box.append(UIImageView, :magnifier) }}
      st.left_view_mode = UITextFieldViewModeAlways
    end
  end

  def fetch_data
    AFMotion::JSON.get("http://api.thisamericanlife.co/q?q=#{@query}") do |response|
      if response.success?
        @episodes = []
        response.object["podcasts"].each do |episode|
          @episodes << Episode.new(episode)
        end
        update_table_data
        end_refreshing
        $notifier.dismiss
      else
        app.alert("Oops. Try again.")
      end
    end
  end

  def table_header_view
    create!(UIView, :header).tap do |view|
      view.append(UITextField, :search)
    end
  end

  def table_data
    [{
      cells:
      if @episodes.size > 0 || !@query
        @episodes.map do |episode|
          {
            cell_class: ListCell,
            properties: { params: { episode: episode } },
            action: :show_episode,
            arguments: episode
          }
        end
      else
        [{ title: "No Results Found" }]
      end
    }]
  end

  def textFieldShouldReturn(field)
    $notifier.loading(:black)
    @query = find(:search).data
    find(:search).get.endEditing(true)
    fetch_data
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

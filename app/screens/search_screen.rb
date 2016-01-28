class SearchScreen < PM::GroupedTableScreen
  title "This American Life"
  stylesheet SearchScreenStylesheet
  row_height :auto, estimated: 100

  def on_init
    set_tab_bar_item title: "Search", item: icon_image(:awesome, :search, size: 25)
  end

  def on_load
    @episodes = []
    tapGesture = UITapGestureRecognizer.alloc.initWithTarget(self, action: :dismiss_keyboard)
    tapGesture.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tapGesture)
  end

  def dismiss_keyboard
    find(:search).get.resignFirstResponder
  end

  def will_appear
    find(:search).style do |st|
      st.view.delegate = self
      st.left_view = create!(UIView, :padding).tap { |padding| padding.append(UIView, :box).tap { |box| box.append(UIImageView, :magnifier) }}
      st.left_view_mode = UITextFieldViewModeAlways
    end
    if @episodes.size == 0
      find(:search).get.becomeFirstResponder
    end
  end

  def fetch_data
    AFMotion::JSON.get("http://api.thisamericanlife.co/q?q=#{@query.strip}") do |response|
      if response.success?
        @episodes = []
        response.object["podcasts"].each do |episode|
          @episodes << Episode.new(episode)
        end
        update_table_data
        end_refreshing
        $notifier.dismiss
      else
        $notifier.dismiss
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
        [{ title: "No episodes found for '#{@query}'." }]
      end
    }]
  end

  def textFieldShouldReturn(field)
    $notifier.loading(:black)
    @query = find(:search).data
    field.endEditing(true)
    fetch_data
  end

  def textFieldShouldClear(field)
    field.endEditing(true)
  end

  def show_episode(episode)
    open ShowScreen.new(nav_bar: true, episode: episode)
  end

end

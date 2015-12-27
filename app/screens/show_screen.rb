class ShowScreen < PM::TableScreen
  title "This American Life"
  stylesheet HomeScreenStylesheet
  row_height :auto, estimated: 100

  attr_accessor :episode

  def table_data
    [{
      cells: [{
        cell_class: ShowCell,
        properties: { params: { episode: @episode } },
        selection_style: :none,
      },{
        cell_class: Button,
        properties: { params: { text: "Play Episode" } },
        action: :play_podcast,
        arguments: @episode.podcast_url
      }]
    }]
  end

  def play_podcast(url)
    BW::Media.play_modal(url)
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

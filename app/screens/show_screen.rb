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
        properties: { params: { text: "Bookmark" } },
        action: :bookmark,
        arguments: @episode
      },{
        cell_class: Button,
        properties: { params: { text: "Play Episode" } },
        action: :play_podcast,
        arguments: @episode.podcast_url
      }]
    }]
  end

  def bookmark(podcast)
    Bookmark.create(number: podcast.number, title: podcast.title, published_on: podcast.date, summary: podcast.description, image_url: podcast.image_url, podcast_url: podcast.podcast_url)
    if cdq.save
      $notifier.success("Episode Bookmarked!")
    else
      $notifier.error("Oops! Try again.")
    end
  end

  def play_podcast(url)
    BW::Media.play_modal(url)
  end

end

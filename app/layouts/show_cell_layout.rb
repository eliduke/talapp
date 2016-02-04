class ShowCellLayout < MotionKit::Layout

  PADDING = 15

  attr_accessor :episode

  def layout
    root :cell do
      add UIImageView, :image
      add UIButton, :play
      add UIButton, :bookmark
      add UILabel, :title
      add UILabel, :date
      add UILabel, :description
    end
  end

  def episode=(episode)
    super
    get(:image).setImageWithURL(NSURL.URLWithString(episode.image_url))
    get(:play).setImage(icon_image(:awesome, :play, color: rmq.color.white, size: 25), forState:UIControlStateNormal)
    get(:bookmark).setImage(icon_image(:awesome, :bookmark, color: rmq.color.white, size: 25), forState:UIControlStateNormal)
    get(:title).text = "#{episode.number}: #{episode.title}"
    get(:date).text = episode.date.to_s.nsdate.string_with_format("MMMM d, yyyy") if episode.date
    get(:description).text = episode.description

    get(:play).off.on(:tap) do
      rmq.screen.play
    end

    get(:bookmark).off.on(:tap) do
      rmq.screen.bookmark
    end
  end

  def image_style
    constraints do
      size.equals(100)
      top_left.equals(:superview).plus(PADDING)
    end
    layer do
      corner_radius 5
      masks_to_bounds true
    end
  end

  def play_style
    constraints do
      size.equals([100, 50])
      top.equals(:image, :bottom).plus(PADDING)
      left.equals(:superview).plus(PADDING)
    end
    layer do
      corner_radius 5
      masks_to_bounds true
    end
    backgroundColor rmq.color.blue
  end

  def bookmark_style
    constraints do
      size.equals([100, 50])
      top.equals(:play, :bottom).plus(PADDING)
      left.equals(:superview).plus(PADDING)
    end
    layer do
      corner_radius 5
      masks_to_bounds true
    end
    background_color rmq.color.red
  end

  def title_style
    constraints do
      top.equals(:superview).plus(PADDING)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    color rmq.color.blue
    font rmq.font.big_bold
    line_break_mode NSLineBreakByWordWrapping
    number_of_lines 0
    size_to_fit
  end

  def date_style
    constraints do
      top.equals(:title, :bottom)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    color rmq.color.red
    font rmq.font.standard_bold
  end

  def description_style
    constraints do
      top.equals(:date, :bottom).plus(PADDING)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
      bottom.equals(:superview).minus(150)
    end
    font rmq.font.standard
    line_break_mode NSLineBreakByWordWrapping
    number_of_lines 0
    size_to_fit
  end

end

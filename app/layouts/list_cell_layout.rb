class ListCellLayout < MotionKit::Layout

  PADDING = 15

  attr_accessor :episode

  def layout
    root :cell do
      add UIImageView, :image
      add UILabel, :title
      add UILabel, :date
      add UILabel, :description
    end
  end

  def episode=(episode)
    super
    get(:image).setImageWithURL(NSURL.URLWithString(episode.image_url))
    get(:title).text = "#{episode.number}: #{episode.title}"
    get(:date).text = episode.date.to_s.nsdate.string_with_format("MMMM d, yyyy")
    get(:description).text = episode.description
  end

  def image_style
    constraints do
      size.equals(100)
      top_left.equals(:superview).plus(PADDING)
      bottom.equals(:superview).minus(PADDING)
    end
    layer do
      corner_radius 5
      masks_to_bounds true
    end
  end

  def title_style
    constraints do
      top.equals(:superview).plus(PADDING)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    font rmq.font.standard_bold
    color rmq.color.blue
  end

  def date_style
    constraints do
      top.equals(:title, :bottom)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    font rmq.font.small_bold
    color rmq.color.red
  end

  def description_style
    constraints do
      top.equals(:date, :bottom).plus(2)
      left.equals(:image, :right).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    font rmq.font.tiny
    line_break_mode NSLineBreakByWordWrapping
    number_of_lines 4
    size_to_fit
  end

end

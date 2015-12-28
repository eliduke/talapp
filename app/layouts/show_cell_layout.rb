class ShowCellLayout < MotionKit::Layout

  PADDING = 15

  attr_accessor :episode

  def layout
    root :cell do
      add UIView, :images do
        add UIImageView, :image_left
        add UIImageView, :image_right
      end
      add UILabel, :title
      add UILabel, :date
      add UILabel, :description
    end
  end

  def episode=(episode)
    super
    image = UIImage.imageWithData(NSData.dataWithContentsOfURL(NSURL.URLWithString(episode.image_url)))
    get(:image_left).image = image
    get(:image_right).image = image
    get(:title).text = "#{episode.number}: #{episode.title}"
    get(:date).text = episode.date.to_s.nsdate.string_with_format("MMMM d, yyyy") if episode.date
    get(:description).text = episode.description
  end

  def images_style
    constraints do
      width.equals(:superview)
      height.equals(165)
      top_left.equals(:superview).plus(PADDING)
    end
  end

  def image_left_style
    constraints do
      size.equals(165)
      top_left.equals(:images)
    end
  end

  def image_right_style
    constraints do
      size.equals(165)
      top.equals(:images)
      left.equals(:image_left, :right).plus(PADDING)
    end
  end

  def title_style
    constraints do
      top.equals(:images, :bottom).plus(PADDING)
      left.equals(:superview).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    font rmq.font.medium_bold
    color rmq.color.red
  end

  def date_style
    constraints do
      top.equals(:title, :bottom)
      left.equals(:superview).plus(PADDING)
      right.equals(:superview).minus(PADDING)
    end
    font rmq.font.standard_bold
    color rmq.color.blue
  end

  def description_style
    constraints do
      top.equals(:date, :bottom).plus(PADDING)
      left.equals(:superview).plus(PADDING)
      right.equals(:superview).minus(PADDING)
      bottom.equals(:superview).minus(PADDING)
    end
    font rmq.font.standard
    line_break_mode NSLineBreakByWordWrapping
    number_of_lines 0
    size_to_fit
  end

end

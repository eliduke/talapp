class ButtonLayout < MotionKit::Layout

  PADDING = 15

  attr_accessor :settings

  def layout
    root :cell do
      add UILabel, :button
    end
  end

  def settings=(settings)
    super
    get(:button).text = settings[:text]
    get(:button).backgroundColor = settings[:color]
  end

  def button_style
    constraints do
      height.equals(50)
      top_left.equals(:superview).plus(PADDING)
      bottom_right.equals(:superview).minus(PADDING)
    end
    layer do
      corner_radius 5
      masks_to_bounds true
    end
    color rmq.color.white
    text_alignment NSTextAlignmentCenter
    font rmq.font.medium
  end

end

class ButtonLayout < MotionKit::Layout

  PADDING = 15

  attr_accessor :text

  def layout
    root :cell do
      add UILabel, :button
    end
  end

  def text=(text)
    super
    get(:button).text = text
  end

  def button_style
    constraints do
      top.equals(:superview)
      left.equals(:superview).plus(PADDING)
      right.equals(:superview).minus(PADDING)
      bottom.equals(:superview)
      height.equals(50)
    end
    color rmq.color.white
    text_alignment NSTextAlignmentCenter
    background_color rmq.color.blue
    font rmq.font.medium
  end

end

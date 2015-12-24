class PlayButtonLayout < MotionKit::Layout

  PADDING = 15

  def layout
    root :cell do
      add UILabel, :play
    end
  end

  def play_style
    constraints do
      top.equals(:superview)
      left.equals(:superview).plus(PADDING)
      right.equals(:superview).minus(PADDING)
      bottom.equals(:superview)
      height.equals(55)
    end
    text "Play Episode"
    color rmq.color.white
    text_alignment NSTextAlignmentCenter
    background_color rmq.color.blue
    font rmq.font.large_bold
  end

end

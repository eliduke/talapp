class PlayButton < UITableViewCell

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @layout = PlayButtonLayout.new(root: WeakRef.new(self)).build
    self
  end

  def updateViewConstraints
    @layout.root.size_to_fit
    super
  end

end

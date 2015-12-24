class ShowCell < UITableViewCell

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @layout = ShowCellLayout.new(root: WeakRef.new(self)).build
    self
  end

  def params=(params)
    @layout.episode = params[:episode]
  end

  def updateViewConstraints
    @layout.root.size_to_fit
    super
  end

end

class Button < UITableViewCell

  def initWithStyle(style, reuseIdentifier: identifier)
    super
    @layout = ButtonLayout.new(root: WeakRef.new(self)).build
    self
  end

  def params=(params)
    @layout.settings = params[:settings]
  end

  def updateViewConstraints
    @layout.root.size_to_fit
    super
  end

end

class AppDelegate < PM::Delegate
  include CDQ
  status_bar true, animation: :fade
  ApplicationStylesheet.new(nil).application_setup

  def on_load(app, options)
    $notifier = Motion::Blitz
    open_tab_bar ListScreen.new(nav_bar: true), SearchScreen.new(nav_bar: true), RandomScreen.new(nav_bar: true), BookmarkScreen.new(nav_bar: true)
    cdq.setup
  end

end

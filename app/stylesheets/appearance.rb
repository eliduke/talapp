# UIAppearance. All settings here apply to all views of that type.
# What you can't do here, do in ApplicationStylesheet
class StandardAppearance
  def self.apply(window)
    Dispatch.once do

      UINavigationBar.appearance.tap do |o|
        o.tintColor = rmq.color.white
        o.barTintColor = rmq.color.red
        o.translucent = false

        o.setTitleTextAttributes( {
          UITextAttributeFont => rmq.font.large,
          UITextAttributeTextColor => rmq.color.white
        })
      end

      UITabBar.appearance.tap do |o|
        o.tintColor = rmq.color.white
        o.barTintColor = rmq.color.blue
        o.translucent = false
      end

      UITableView.appearance.tap do |o|
        o.separatorColor = rmq.color.clear
      end

      UITextField.appearance.tap do |o|
        o.clearButtonMode = UITextFieldViewModeAlways
      end

    end
  end
end


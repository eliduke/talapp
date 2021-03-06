class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup

    regular = 'Helvetica Neue'
    font.add_named :very_large,  regular, 56
    font.add_named :large,       regular, 24
    font.add_named :big,         regular, 20
    font.add_named :medium,      regular, 18
    font.add_named :standard,    regular, 16
    font.add_named :small,       regular, 14
    font.add_named :tiny,        regular, 12
    font.add_named :nano,        regular, 10

    bold = 'HelveticaNeue-Bold'
    font.add_named :large_bold,     bold, 24
    font.add_named :big_bold,       bold, 20
    font.add_named :medium_bold,    bold, 18
    font.add_named :standard_bold,  bold, 16
    font.add_named :small_bold,     bold, 14

    color.add_named :blue, '442A56'
    color.add_named :red, 'E93E2F'
    color.add_named :light_gray, '#eaeaea'
    color.add_named :medium_gray, '#c0c0c0'
    color.add_named :dark_gray, '#404040'
    color.add_named :translucent_black, color(0, 0, 0, 0.4)

    StandardAppearance.apply app.window

  end

  def root_view(st)
    st.background_color = color.light_gray
  end

  def standard_button(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.tint
    st.color = color.white
  end

  def standard_label(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.clear
    st.color = color.black
  end

  def rounded_image(st)
    st.view.layer.cornerRadius = st.frame.width/2
    st.clips_to_bounds = true
  end

end

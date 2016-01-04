class SearchScreenStylesheet < ApplicationStylesheet

  def header(st)
    st.frame = {t: 0, l: 0, w: device.width, h: 60}
  end

  def search(st)
    st.frame = {t: 15, l: 15, w: device.width - 30, h: 30}
    st.background_color = color.white
    st.font = font.standard
    st.corner_radius = 5
    st.placeholder = "Looking for something?"
    st.return_key_type = :search
  end

  def padding(st)
    st.frame = { h: 30, w: 40 }
  end

  def box(st)
    st.frame = { h: 30, w: 30 }
    st.background_color = color.blue
  end

  def magnifier(st)
    st.frame = { l: 8, t: 7, h: 15, w: 15 }
    st.image = icon_image(:awesome, :search, color: color.white)
  end

end
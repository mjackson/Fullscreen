class FullscreenWindow < NSWindow

  # This method returns +false+ for NSBorderlessWindowMask windows, so we need
  # to override it here to return +true+.
  def canBecomeKeyWindow
    true
  end

end

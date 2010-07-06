class FullscreenAppDelegate

  # The presentation options that will be active when in fullscreen mode. These
  # say that both the Dock and system menu bar will take on autohide behavior.
  PresentationOptions = NSApplicationPresentationAutoHideDock |
    NSApplicationPresentationAutoHideMenuBar

  attr_accessor :mainWindow

  attr_reader :fullscreenWindow

  def mainScreen
    NSScreen.screens[0]
  end

  def mainRect
    mainWindow.contentRectForFrameRect(mainWindow.frame)
  end

  def toggleFullscreen(sender)
    if fullscreenWindow
      # Resize the fullscreen window to the size of the main window.
      newFrame = fullscreenWindow.frameRectForContentRect(mainRect)
      fullscreenWindow.setFrame(newFrame, display:true, animate:true)

      # Move the content view to the main window.
      contentView = fullscreenWindow.contentView
      fullscreenWindow.setContentView(NSView.alloc.init)
      mainWindow.setContentView(contentView)

      # Show the main window.
      mainWindow.makeKeyAndOrderFront(nil)

      # Get rid of the fullscreen window.
      fullscreenWindow.close
      @fullscreenWindow = nil

      # Reset the presentation options.
      NSApp.setPresentationOptions(@oldPresentationOptions)
    else
      # Deminiaturize the window, in case it has been docked.
      mainWindow.deminiaturize(nil)

      # Record presentation options so we can reset them when we exit
      # fullscreen.
      @oldPresentationOptions = NSApp.presentationOptions
      NSApp.setPresentationOptions(PresentationOptions)

      @fullscreenWindow = FullscreenWindow.alloc.initWithContentRect(mainRect,
        styleMask:NSBorderlessWindowMask,
        backing:NSBackingStoreBuffered,
        defer:true)

      # Move the content view to the fullscreen window.
      contentView = mainWindow.contentView
      mainWindow.setContentView(NSView.alloc.init)
      fullscreenWindow.setContentView(contentView)

      # The fullscreen window should be floating so it will appear above
      # NSPanels and similar.
      fullscreenWindow.setLevel(NSFloatingWindowLevel)

      # The fullscreen window should have the same title as the main window
      # so that it will appear the same in Expose.
      fullscreenWindow.setTitle(mainWindow.title)

      # Show the fullscreen window.
      fullscreenWindow.makeKeyAndOrderFront(nil)

      # Resize the fullscreen window to the size of the screen.
      targetFrame = mainWindow.screen.frame
      newFrame = fullscreenWindow.frameRectForContentRect(targetFrame)
      fullscreenWindow.setFrame(newFrame, display:true, animate:true)

      # Hide the main window.
      mainWindow.orderOut(nil)
    end
  end

end

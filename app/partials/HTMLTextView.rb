class HTMLTextView < UIWebView
  def initWithFrame(frame)
    super
    self.delegate = self
  end
  def setText(str)
    str = str.gsub("\n", "<br>")
    str = "<html><head></head><body><div id='content'>"+styles+str+"</div></body></html>"
    str = process_links(str)
    self.loadHTMLString(str, baseURL:NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath));
  end
  def process_links(str)
    out = '';
    words = str.split(" ")
    words.each do |w|
      pure = w.gsub("<br>", "").gsub(/<[^>]*>/, "")
      pure.strip!
      if pure.start_with?("http://", "https://")
        htmld = '<a href="'+pure+'" target="_blank">'+pure+'</a>'
        w = w.sub(pure, htmld)
      end
      out += w + ' '
    end
    out
  end
  def styles
    '<style type="text/css">
      body { font-family: "Karla"; font-size:15px; }
      a { color: #E99533; text-decoration: underline; }
    </style>'
  end
  def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)
    if inType == UIWebViewNavigationTypeLinkClicked
      UIApplication.sharedApplication.openURL(inRequest.URL)
      false
    else
      true
    end
  end
end

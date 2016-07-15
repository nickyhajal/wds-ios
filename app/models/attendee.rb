class Attendee
  attr_accessor :user_id, :first_name, :last_name, :full_name, :ticket_type, :email, :user_name, :twitter, :instagram, :facebook, :pic, :location, :lat, :lon, :distance, :qnaStr, :isQna
  def initialize(atn)
    if atn == 'default'
      @first_name = '░░░░░░░░░'
      @last_name = '░░░░░░░░'
      @distance = '░░░░░░'
      @location = '░░░░░░░░'
      @user_id = 0
    else
      atn.each do |key, value|
        self.instance_variable_set("@#{key}".to_sym, value)
      end
      unless @distance.nil?
        @distance = @distance.to_i.ceil.to_s
        @distance = '2' if distance < '1'
        @distance = '' if @distance.nil?
      end
    end
    @full_name = @first_name + ' ' + @last_name
    @pic = "http://avatar.wds.fm/"+@user_id.to_s
    @qnaStr = qna
    @isQna = @qnaStr.length > 0
  end
  def getPic(size)
    "http://avatar.wds.fm/"+(@user_id.to_s)+"?width="+(size.to_s)
  end
  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var).to_s }
    hash
  end
  def clean_site
    @site.gsub('https://', '').gsub('http://', '').gsub('www.', '').downcase
  end
  def connect_buttons
    btns = []
    get_facebook_id
    if !@site.nil? && @site.length > 0
      btns << [clean_site, self, 'goto_site_action']
    end
    if !@twitter.nil? && @twitter.length > 0
      btns << ['@'+@twitter.downcase, self, 'goto_twitter_action']
    end
    if !@facebook.nil? && @facebook.length > 0
      btns << ['fb.com/'+@facebook.downcase, self, 'goto_facebook_action']
    end
    if !@instagram.nil? && @instagram.length > 0
      btns << ['ig.com/'+@instagram.downcase, self, 'goto_instagram_action']
    end
    btns
  end
  def qna
    str = ''
    if !@answers.nil? && @answers.length
      answers = BW::JSON.parse(@answers)
      location = ''
      if !@location.nil? && @location.length > 0
        location = 'from '+@location
      end
      qs = ['',
        'Why did you decide to travel '+@distance+' miles '+location+' to the World Domination Summit?',
        'What are you excited about these days?',
        'What\'s your super power?',
        'What\'s your goal for WDS 2016?',
        'What\'s your favorite song?',
        'What\'s your favorite treat?',
        'What\'s your favorite quote?',
        'What are you looking forward to during your time in Portland?'
      ]
      answers.each do |answer|
        unless qs[answer[:question_id]].nil?
          str += ' <b style="margin-bottom:14px;">'+qs[answer[:question_id]]+'</b> <div style="margin-bottom:20px">'+answer[:answer]+'</div>'
        end
      end
      str
    else
      ''
    end
  end
  def get_facebook_id
    return nil
    if !@facebook.nil? && @facebook.length
      AFMotion::JSON.get 'http://graph.facebook.com/'+@facebook, {} do |rsp|
        rsp = Response.new(rsp)
        if rsp[:json] && !rsp[:json][:id].nil?
          @facebook_id = rsp.id
        end
      end
    end
  end
  def goto_url(url)
    UIApplication.sharedApplication.openURL(url.nsurl)
    # openIn = OpenInChromeController.new
    # if 0 && openIn.isChromeInstalled
    #   openIn.openInChrome(url, withCallbackURL:'wds://profile', createNewTab:true)
    # else
    # end
  end
  def goto_site_action
    goto_url('http://'+@site)
  end
  def goto_twitter_action
    url = 'http://twitter.com/'+@twitter
    if UIApplication.sharedApplication.canOpenURL("twitter://".nsurl)
      url = "twitter://user?screen_name="+@twitter
      UIApplication.sharedApplication.openURL(url.nsurl)
    else
      goto_url(url)
    end
  end
  def goto_facebook_action
    url = 'http://facebook.com/'+@facebook
    # if !@facebook_id.nil? && UIApplication.sharedApplication.canOpenURL("fb://".nsurl)
      # url = "fb://profile/"+@facebook_id
      #UIApplication.sharedApplication.openURL(url.nsurl)
    # else
    goto_url(url)
    # end
  end
  def goto_instagram_action
    url = 'http://instagram.com/'+@instagram
    if UIApplication.sharedApplication.canOpenURL("instagram://".nsurl)
      url = "instagram://user?username="+@instagram
      UIApplication.sharedApplication.openURL(url.nsurl)
    else
      goto_url(url)
    end
  end
end

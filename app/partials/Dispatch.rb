class Disptch < PM::TableScreen
  attr_accessor :controller, :items, :active
  title "Dispatch"
  row_height 144
  refreshable
  def setWidth(width)
    @width = width
  end
  def initFilters(layout)
    filters = Store.get('dispatch_filters', true)
    active = true
    unless filters
      filters = {
        twitter: 1,
        following: 0,
        communities: 0,
        events: 0
      }
    end
    setFilters filters, true, true
    filters[:events] = 0 if filters[:events].nil?
    layout.get(:twitter_selector).setSelectedSegmentIndex filters[:twitter]
    layout.get(:friends_selector).setSelectedSegmentIndex filters[:following]
    layout.get(:communities_selector).setSelectedSegmentIndex filters[:communities]
    layout.get(:events_selector).setSelectedSegmentIndex filters[:events]
  end
  def unwatch
    if !@watching.nil? and @watching
      Fire.unwatch(@watching)
      @watching = false
    end
  end
  def watch
    unwatch
    channel_type = @params[:channel_type] || 'global'
    channel_id = @params[:channel_id].nil? || !@params[:channel_id] ? '0': @params[:channel_id].to_s
    key = '/feeds/' + channel_type + '_' + channel_id
    @watching = Fire.watch "value", key do |rsp|
      unless rsp.value.nil?
        fetchUpdates unless @fetchingContent
      end
    end
  end
  def fullHeight
    @controller.layout.super_height - 86
  end
  def bannerHeight
    58
  end
  def setFilters(filters = false, do_update = true, continueUpdating = false)
    unless filters
      filters = Store.get('dispatch_filters', true)
    end
    @filters = filters
    if do_update
      update
      # 15.seconds.later do
      #   fetchUpdates(continueUpdating)
      # end
    end
  end
  def setNewPostsBtn(view, const, mainView)
    @mainView = mainView
    @newYConstraint = const
    @newBtn = view
  end
  def initParams(opts, fetch = true, clear = true)
    @numRetries = 0
    @waitingForScrollStop = []
    @loadingViaScroll = false
    @startDragY = false
    @scrollWhenLoaded = false
    @params = {}
    @filters = {}
    @params[:include_author] = 1
    unless opts[:channel_type].nil?
      @channel_type = opts[:channel_type]
      @params[:channel_type] = @channel_type
    end
    unless opts[:channel_id].nil?
      @channel_id = opts[:channel_id]
      @params[:channel_id] = @channel_id
    end
    unless opts[:user_id].nil?
      @user_id = opts[:user_id]
      @params[:user_id] = @user_id
    end
    @since = 0
    watch
    if clear
      clear
    end
  end
  def setCommunity(community_id)
    setChannel('interest', community_id)
  end
  def leaveChannel
    setChannel('global')
  end
  def setChannel(channel_type, channel_id = false)
    @since = 0
    @params[:channel_type] = channel_type
    if channel_id
      @params[:channel_id] = channel_id
    else
      @params.delete(:channel_id)
    end
    update
    watch
  end
  def on_load
    @items = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
    @refresh_control.alpha = 0.7
  end
  def table_data
    for i in 0..(@items.length-1)
      @items[i][:properties][:inx] = i
    end
    [{cells: @items}]
  end
  def clear
    @items = []
    update_table_data
  end
  def make_cell(item)
    height = calcCellHeight(item)
    {
      title: '',
      cell_class: DispatchCell,
      # action: :item_tap_action,
      arguments: { item: item},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        item: item,
        height: height,
        width: @width,
        controller: @controller,
        table: self,
        type: item.type
      }
    }
  end
  def clean_items(items)
    out = []
    items.each do |item|
      if item[:properties][:type] == 'item'
        out << item
      end
    end
    out
  end
  def hideFirst
    @items[0][:properties][:height] = 0
    @items[1][:properties][:item].top_padding = 3
    self.tableView.beginUpdates
    self.tableView.endUpdates
  end
  def update_cell_height(inx, height, state = false, id = false)
    @items[inx][:properties][:height] = height
    if state
      @items[inx][:properties][:item].state = state
      if id
        Store.set("#{id}_state", state)
      end
    end
    self.tableView.beginUpdates
    self.tableView.endUpdates
  end
  def add_special_tiles(items)

    ### COMMENT THIS OUT BEFORE PUBLISHING
    # Store.set('preorder', 'do_pre')
    #### ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    pre = Store.get('preorder17')
    atnstory = Store.get('atnstory17')
    preState = Store.get('preorder17_state')
    today = NSDate.new.string_with_format(:iso8601)
    preState = 'open' unless preState
    if $STATE.nil?
      $STATE = {special: 'none', ios_version: '0'}
    end

    ### CHECK IF NOT PURCHASED
    ### IF MARKED LIVE IN FIREBASE
    if ($STATE[:ios_version] > $VERSION)
      tile = DispatchItem.new({
        'type' => 'update',
        'height' => bannerHeight,
        'state' =>'open'
      })
      items.unshift(make_cell(tile))
    elsif ($STATE[:special] == 'attendee-stories') and atnstory != 'submitted'
      tile = DispatchItem.new({
        'type' => 'attendee-stories',
        'height' => bannerHeight,
        'state' => 'open'
      })
      items.unshift(make_cell(tile))
    elsif (!pre || pre == "do_pre") and ($STATE[:test17_special] == 'preorder')
      tile = DispatchItem.new({
        'type' => 'tckt',
        'height' => (preState == 'open' ? fullHeight : bannerHeight),
        'state' => preState
      })
      items.unshift(make_cell(tile))
    elsif pre == "purchased"
      tile = DispatchItem.new({
        'type' => 'post-tckt',
        'height' => fullHeight,
        'state' => 'open'
      })
      items.unshift(make_cell(tile))
    end
    items
  end
  def update_content(items)
    cells = []
    items.each do |item|
      unless item.class.to_s.include?('Item')
        item = DispatchItem.new(item)
      end
      item = make_cell item
      cells << item
    end
    unless @items[0].nil?
      @items[0][:properties][:item].top_padding = 0
    end
    @items = cells + @items
    @items = clean_items(@items)
    @items = add_special_tiles(@items)
    if @items[0].nil?
      @since = 0
    else
      i = 0
      @items[i][:properties][:item].top_padding = 3
      while (!@items[i].nil?) && @items[i][:properties][:type] != 'item'
        i += 1
      end
      if !@items[i].nil?
        @since = @items[i][:properties][:item].feed_id
      else
        @since = 0
      end
    end
    update_table_data
  end
  def prepend_content(items)
    cells = []
    items.each do |item|
      unless item.class.to_s.include?('DispatchItem')
        item = DispatchItem.new(item)
      end
      item = make_cell item
      cells << item
    end
    @items = @items + cells
    update_table_data
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.promotion_table_data.cell(index_path: index_path)
    cell[:properties][:height]
  end
  def calcCellHeight(item)
    if item.respond_to?('height') and !item.height.nil? and item.height > 0
      height = item.height
    else
      contentStr = item.content.nsattributedstring({
        NSFontAttributeName => Font.Karla(15),
        UITextAttributeTextColor => Color.coffee
      })
      size = self.frame.size
      size.width = @width - 32
      size.height = Float::MAX
      content = contentStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      height = 5 + 38 + 5 + content.size.height.ceil + 40 + item.top_padding
    end
    height.to_f
  end
  def post(text, &block)
    Api.post 'feed', {content: text, channel_type: @params[:channel_type], channel_id: @params[:channel_id]} do |rsp|
      unless rsp.is_err
        update
      end
      block.call rsp.is_err
    end
  end
  def loadMore
    last_id = 0
    if @items.length > 0
      last_id = @items.last[:properties][:item].feed_id
    end
    fetchContent last_id
  end
  def loadNew
    fetchContent
  end
  def loadNewViaButton
    @scrollWhenLoaded = true
    self.tableView.setContentOffset(CGPointMake(0, -self.tableView.contentInset.top), animated: true)
    loadNew
    hideNewPostButton
  end
  def update
    @items = []
    @since = 0
    fetchContent
    self.tableView.setContentOffset(CGPointMake(0, -self.tableView.contentInset.top), animated: false)
  end
  def displayNewPostNotification(num_posts)
    unless num_posts.nil?
      if num_posts > 0
        showNewPostButton(num_posts)
      else
      end
    end
  end
  def showNewPostButton(num_posts)
    if num_posts > 0
      posts = num_posts == 1 ? 'post' : 'posts'
      text = num_posts.to_s+' new '+posts
      @newBtn.title = text
      if @newBtn.isHidden
        @newBtn.hidden = false
        @newYConstraint.plus(70)
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
          @mainView.layoutIfNeeded  # applies the constraint change
        end, completion: nil)
      end
    end
  end
  def hideNewPostButton
    @newYConstraint.minus(70)
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      @mainView.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    0.2.seconds.later do
      @newBtn.hidden = true
    end
  end
  def fetchUpdates(continueFetch = true)
    puts 'FETCH UPDATES'
    params = @params.clone
    feed_ids = @items.select{ |i| i[:properties][:item].respond_to?('feed_id')}
    .map do |i|
      i[:properties][:item].feed_id
    end
    params[:since] = @since
    params[:feed_ids] = feed_ids
    if params[:channel_type] == 'global'
      params[:filters] = @filters
    end
    Api.get 'feed/updates', params do |rsp|
      if !rsp.is_err && rsp[:count] && @active
        displayNewPostNotification rsp.count
      end
      if !rsp.is_err && rsp[:updates]
        updates = rsp.updates
        inx = 0
        inxs = []
        @items.each do |item|
          item = item[:properties][:item] unless item[:properties][:item].nil?
          if item.respond_to?('feed_id')
            id = 'feed_'+item.feed_id.to_s
            unless updates[id].nil?
              likes = updates[id][:num_likes]
              comments = updates[id][:num_comments]
              changed = false
              if item.num_likes != likes
                item.num_likes = likes
                changed = true
              end
              if item.num_comments != comments
                item.num_comments = comments
                changed = true
              end
              if changed
                @items[inx][:properties][:item] = item
                @items[inx][:arguments][:item] = item
                inxs << NSIndexPath.indexPathForRow(inx, inSection:0)
              end
            end
          end
          inx += 1
        end
        if inxs.length > 0
          update_table_data({index_paths: inxs})
        end
      end
    end
    # if continueFetch
    #   10.seconds.later do
    #     fetchUpdates
    #   end
    # end
  end
  def fetchContent(before = false, waitForScrollStop = false)
    @fetchingContent = true
    params = @params.clone
    params[:since] = @since
    params[:before] = before if before
    if params[:channel_type] == 'global'
      params[:filters] = @filters
    end
    Api.get 'feed', params do |rsp|
      @fetchingContent = false
      if rsp.is_err
        stop_refreshing
        frame = self.tableView.frame
        @error.removeFromSuperview unless @error.nil?
        @error2.removeFromSuperview unless @error2.nil?
        @error = UILabel.alloc.initWithFrame [[0, 100], [frame.size.width, 40]]
        @error.text = "Looks like you're offline"
        @error.font = Font.Vitesse_Medium(18)
        @error.textColor = Color.dark_gray
        @error.textAlignment = NSTextAlignmentCenter
        @error2 = UITextView.alloc.initWithFrame [[20, 130], [frame.size.width-40, 80]]
        @error2.text = "The Dispatch will be back once it can connect to WDS HQ."
        @error2.font = Font.Karla_Bold(15)
        @error2.editable = false
        @error2.textColor = Color.dark_gray
        @error2.textAlignment = NSTextAlignmentCenter
        @error2.backgroundColor = Color.clear
        @items = []
        update_table_data
        self.tableView.addSubview @error
        self.tableView.addSubview @error2
        recheckConnectivity
      else
        hideNullMsg
        @numRetries = 0
        @error.removeFromSuperview unless @error.nil?
        @error2.removeFromSuperview unless @error2.nil?
        if before
          @loadingViaScroll = false
          if rsp.feed_contents.length > 0
            prepend_content rsp.feed_contents
          else
            if (EventTypes.types.include?(@channel_type))
              showNullMsg
            end
          end
        else
          if rsp.feed_contents.length > 0
            update_content rsp.feed_contents
          else
            if (EventTypes.types.include?(@channel_type))
              showNullMsg
            else
              update_content([])
            end
          end
        end
        if @scrollWhenLoaded
          @scrollWhenLoaded = false
          0.2.seconds.later do
            self.tableView.setContentOffset(CGPointMake(0, -self.tableView.contentInset.top), animated: true)
          end
        end
        stop_refreshing
      end
    end
  end
  def showNullMsg
    hideNullMsg
    frame = self.tableView.frame
    @null = UILabel.alloc.initWithFrame [[0, 100], [frame.size.width, 40]]
    @null.text = "No messages here...yet!"
    @null.font = Font.Vitesse_Medium(18)
    @null.textColor = Color.dark_gray
    @null.textAlignment = NSTextAlignmentCenter
    self.tableView.addSubview @null
  end
  def hideNullMsg
    @null.removeFromSuperview unless @null.nil?
  end
  def recheckConnectivity
    seconds = 10
    if @numRetries > 10
      seconds = 30
    elsif @numRetries > 30
      seconds = 60
    end
    seconds.seconds.later do
      @since = 0
      @numRetries += 1
      fetchContent
    end
  end
  def on_refresh
    loadNew
  end
  def scrollViewDidScroll(scrollView)
    height = scrollView.contentSize.height
    y = scrollView.contentOffset.y
    pcnt = y/height * 100
    if pcnt > 70 and !@loadingViaScroll
      @loadingViaScroll = true
      0.1.seconds.later do
        loadMore
      end
    end
  end

  ## We use this to make sure that we don't pull new content
  ## unless actually pulling down from the top
  def scrollViewWillBeginDragging(scrollView)
    @startDragY = scrollView.contentOffset.y
  end
  def scrollViewWillEndDragging(scrollView)
    @startDragY = false
  end
end

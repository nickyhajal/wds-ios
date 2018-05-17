class DispatchContentList < PM::TableScreen
  attr_accessor :controller
  title "Dispatch"
  row_height 144
  refreshable
  def setWidth(width)
    @width = width
  end
  def setLoadingView(view, loading_width, loading_height)
    @loading_view = view
    @loading_width = loading_width
    @loading_height = loading_height
  end
  def on_load
    @items = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
  end
  def on_refresh
    fetchComments
  end
  def updateItem(item)
    @item = item
    @comments = []
    @items = []
    update_content
    fetchComments
  end
  def table_data
    [{cells: @items}]
  end
  def make_cell(item, top_padding = 0)
    height = calcCellHeight(item)
    type = 'loading'
    if item.class.to_s.include?('DispatchItem')
      type = 'dispatch'
    elsif item.class.to_s.include?('Comment')
      type = 'comment'
    end
    {
      title: '',
      cell_class: DispatchContentCell,
      # action: :item_tap_action,
      arguments: { item: item},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        item: item,
        height: height,
        width: @width,
        top_padding: top_padding,
        type: type,
        num_comments: @comments.length,
        controller: @controller
      }
    }
  end
  def update_content(msg = 'Loading Comments...')
    cells = []
    cells << make_cell(@item, 3)
    if @comments.count > 0
      @comments.each do |comment|
        comment = Comment.new(comment)
        cells << make_cell(comment)
      end
    else
      cells << make_cell(msg)
    end
    @items = cells
    update_table_data
  end
  def tableView(table_view, heightForRowAtIndexPath:index_path)
    cell = self.promotion_table_data.cell(index_path: index_path)
    cell[:properties][:height]
  end
  def calcCellHeight(item)
    size = self.frame.size
    size.width = @width - 6 - 35
    size.height = Float::MAX
    padding = 0
    if item.class.to_s.include?('DispatchItem')
      contentStr = item.content.nsattributedstring({
        NSFontAttributeName => Font.Karla(15),
        UITextAttributeTextColor => Color.coffee
      })
      padding = 74
      if item.mediaUrl 
        padding += (UIScreen.mainScreen.bounds.size.width * 0.75) - 6
      end
    elsif item.class.to_s.include?('Comment')
      contentStr = item.comment.nsattributedstring({
        NSFontAttributeName => Font.Karla(14),
        UITextAttributeTextColor => Color.coffee
      })
      padding = 74
    else
      contentStr = item.nsattributedstring({
        NSFontAttributeName => Font.Karla_Italic(14),
        UITextAttributeTextColor => Color.coffee
      })
      padding = 20
    end
    content = contentStr.boundingRectWithSize(size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
    height = padding + content.size.height.ceil+20
    height.to_f
  end
  def fetchComments(scrollToBottomAfterLoad = false)
    params = {
      feed_id: @item.feed_id,
      include_author: 1
    }
    Api.get 'feed/comments', params, do |rsp|
      if rsp.is_err
        frame = self.tableView.frame
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
        self.tableView.addSubview @error
        self.tableView.addSubview @error2
      else
        @error.removeFromSuperview unless @error.nil?
        @error2.removeFromSuperview unless @error2.nil?
        @comments = rsp.comments
        @loadingViaScroll = false
        update_content("No comments...yet.")
      end
      if scrollToBottomAfterLoad
        0.5.seconds.later do
          scrollToBottom
        end
      end
      stop_refreshing
    end
  end
  def scrollViewDidScroll(scrollView)
    height = scrollView.contentSize.height
    y = scrollView.contentOffset.y
    pcnt = y/height * 100
    if pcnt > 70 and !@loadingViaScroll
      @loadingViaScroll = true
      #loadMore
    end
  end

  def scrollToBottom
    self.tableView.scrollToRowAtIndexPath(NSIndexPath.indexPathForRow(@items.count-1, inSection: 0), atScrollPosition: UITableViewScrollPositionBottom, animated: false)
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
class CommunityCell < PM::TableViewCell
  attr_accessor :community, :layout, :width, :controller, :nameStr, :membersStr, :joinStr, :member, :arrowStr
  def will_display
    setNeedsDisplay
  end

  def initWithStyle(style, reuseIdentifier: id)
    @_item = false
    @currentStr = ''
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'singleTap:')
    addGestureRecognizer(singleFingerTap)
    super
  end

  def prepareText
    if @cardView.nil?
      @cardView = CommunityCellInnerView.alloc.initWithFrame([[0, 0], [frame.size.width, frame.size.height]])
      @cardView.cell = self
      addSubview(@cardView)
    end
    @nameStr = @community.interest.nsattributedstring(NSFontAttributeName => Font.Karla_Bold(16),
                                                      UITextAttributeTextColor => Color.dark_gray)
    members = @community.members.to_s + ' members'
    @membersStr = members.nsattributedstring(NSFontAttributeName => Font.Karla_Bold(13),
                                             UITextAttributeTextColor => Color.orangish_gray)
    @member = false
    @arrowStr = Ion.icons[:ios_arrow_forward].attrd({
      NSFontAttributeName => IonIcons.fontWithSize(20),
      UITextAttributeTextColor => Color.orangish_gray(0.6)
    })
    if Me.isInterested @community.interest_id
      @member = true
      joinStr = 'Joined'
    else
      joinStr = 'Join'
    end
    @joinStr = joinStr.nsattributedstring(NSFontAttributeName => Font.Karla_Bold(16),
                                          UITextAttributeTextColor => @member ? Color.white : Color.orange)
  end

  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    x = pnt.x
    size = frame.size
    width = size.width
    height = size.height
    rects = {
      join: joinRect
    }
    hitButton = false
    rects.each do |name, rect|
      if CGRectContainsPoint(rect, pnt)
        send(name + '_action')
        hitButton = true
      end
    end
    @controller.select_community_action @community unless hitButton
  end

  def nameRect
    CGRectMake(10, 7, 380, 38)
  end

  def membersRect
    CGRectMake(10, 26, 380, 38)
  end

  def arrowRect
    x = self.frame.size.width - joinRect.size.width - 42
    y = 15.5
    CGRectMake(x, y, 24, 50)
  end

  def joinRect
    joinWidth = 75
    padding = @member ? 8 : 9
    CGRectMake(frame.size.width - joinWidth - padding, padding, joinWidth, frame.size.height - (padding * 2))
  end

  ## Draw the TableCell
  def drawRect(rect)
    # Init
    prepareText
    unless @cardView.nil?
      @cardView.setFrame(rect)
      @cardView.setNeedsDisplay
    end
  end

  def join_action
    Me.joinCommunity @community.interest_id do |members|
      puts members
      @community.members = members
      setNeedsDisplay
    end
  end
end

class CommunityCellInnerView < UIView
  attr_accessor :cell
  def drawRect(rect)
    size = rect.size
    bg = Color.light_tan
    btnBg = Color.orange
    cardBg = Color.white
    lineBg = Color.light_gray(0.3)

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, size.width, size.height), cornerRadius: 0.0)
    bg.setFill
    bgPath.fill
    @cell.nameStr.drawAtPoint(@cell.nameRect.origin)
    @cell.membersStr.drawAtPoint(@cell.membersRect.origin)

    # Join
    joinBtnPath = UIBezierPath.bezierPathWithRoundedRect(@cell.joinRect, cornerRadius: 4.0)
    btnBg.setFill
    btnBg.setStroke
    if @cell.member
      joinBtnPath.fill
    else
      joinBtnPath.stroke
    end

    @cell.joinStr.drawAtPoint(CGPointMake(@cell.joinRect.origin.x + ((@cell.joinRect.size.width / 2 + 1) - (@cell.joinStr.size.width / 2)), (8 + @cell.joinRect.size.height / 2) - (@cell.joinStr.size.height / 2)))
    @cell.arrowStr.drawInRect(@cell.arrowRect)

    # Line
    linePath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, rect.size.height - 1, rect.size.width, 1), cornerRadius: 0.0)
    lineBg.setFill
    linePath.fill
  end
end

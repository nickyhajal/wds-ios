class CommunityCell < PM::TableViewCell
  attr_accessor :community, :layout, :width, :controller
  def will_display
    self.setNeedsDisplay
  end
  def initWithStyle(style, reuseIdentifier:id)
    @_item = false
    @currentStr = ''
    singleFingerTap = UITapGestureRecognizer.alloc.initWithTarget(self, action:'singleTap:')
    self.addGestureRecognizer(singleFingerTap)
    super
  end
  def prepareText
    @nameStr = @community.interest.nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(16),
      UITextAttributeTextColor => Color.dark_gray
    })
    members = @community.members.to_s+" members"
    @membersStr = members.nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(13),
      UITextAttributeTextColor => Color.orangish_gray
    })
    @member = false
    if Me.isInterested @community.interest_id
      @member = true
      joinStr = 'Joined'
    else
      joinStr = 'Join'
    end
    @joinStr = joinStr.nsattributedstring({
      NSFontAttributeName => Font.Karla_Bold(16),
      UITextAttributeTextColor => Color.white
    })
  end
  def singleTap(theEvent)
    pnt = theEvent.locationInView(theEvent.view)
    y = pnt.y
    x = pnt.x
    size = self.frame.size
    width = size.width
    height = size.height
    rects = {
      join: joinRect
    }
    hitButton = false
    rects.each do |name, rect|
      if CGRectContainsPoint(rect, pnt)
        self.send(name+'_action')
        hitButton = true
      end
    end
    unless hitButton
      @controller.select_community_action @community
    end
  end
  def nameRect
    CGRectMake(10, 7, 380, 38)
  end
  def membersRect
    CGRectMake(10, 26, 380, 38)
  end
  def joinRect
    joinWidth = 75
    CGRectMake(self.frame.size.width-joinWidth,0, joinWidth, self.frame.size.height)
  end

  ## Draw the TableCell
  def drawRect(rect)
    # Init
    prepareText
    size = rect.size
    bg = Color.light_tan
    btnBg = @member ? Color.green : Color.orange
    cardBg = Color.white
    lineBg = Color.light_gray(0.3)

    # Background
    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, size.width, size.height), cornerRadius:0.0)
    bg.setFill
    bgPath.fill
    @nameStr.drawAtPoint(nameRect.origin)
    @membersStr.drawAtPoint(membersRect.origin)

    # Join
    joinBtnPath = UIBezierPath.bezierPathWithRoundedRect(joinRect, cornerRadius:0.0)
    btnBg.setFill
    joinBtnPath.fill
    @joinStr.drawAtPoint(CGPointMake(joinRect.origin.x+((joinRect.size.width/2) - (@joinStr.size.width/2)), (joinRect.size.height/2)-(@joinStr.size.height/2)))

    # Line
    linePath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, rect.size.height-1, rect.size.width, 1), cornerRadius:0.0)
    lineBg.setFill
    linePath.fill
  end

  def join_action
    Me.joinCommunity @community.interest_id do
      self.setNeedsDisplay
    end
  end

end
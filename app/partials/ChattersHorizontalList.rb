class ChattersHorizontalList < MK::Layout
  view :list
  def layout
    @_list = ChattersHorizontalCollection.new
    @_list.setLayout self
    self.list = @_list.view
    root :main do
      add list, :list
    end
  end

  def setController(controller)
    @controller = controller
  end

  def setAdmins(admins)
    @_list.setAdmins(admins)
  end

  def setLayout(layout)
    @layout = layout
  end

  def select_atn(atn)
    @controller.select_atn(atn)
  end

  def remove(atn)
    @controller.remove(atn)
  end

  def setChatters(atns)
    @_list.setChatters atns
  end

  def main_style
    backgroundColor '#FCFCF3'.uicolor
  end

  def list_style
    backgroundColor '#FCFCF3'.uicolor
    constraints do
      top 0
      left 0
      height 64
      width.equals(:superview)
    end
  end
end

class ChattersHorizontalCell < ProMotion::CollectionViewCell
  attr_accessor :atn, :width, :controller, :admin

  def setup(cell_data, screen)
    @atn = cell_data[:atn].stringify_keys
    @admin = cell_data[:admin]
    @controller = cell_data[:controller]
    on_tap do
      @controller.select_atn(@atn)
    end
    super
  end
  def on_reuse
    setNeedsDisplay
  end

  def drawRect(rect)
    # Init
    unless @atn.nil?
      first_name = @atn['first_name'].strip
      if first_name.length > 5
        first_name = first_name[0..4]+'...'
      end
      last_initial = @atn['last_name'][0].upcase
      @name = "#{first_name} #{last_initial}."
      size = rect.size
      @size = size

      @avatar_view ||= begin
        avSize = 34
        av = UIImageView.alloc.initWithFrame([[rect.size.width / 2 - avSize / 2, 7], [avSize, avSize]])
        self.addSubview av
        av
      end
      @dots_view ||= begin
        dots = ChatterDots.alloc.initWithFrame([[rect.size.width - 23, 6], [25, 17]])
        dots.backgroundColor = Color.clear
        self.addSubview dots
        dots
      end
      @dots_view.setAdmin(@admin)

      url = 'https://avatar.wds.fm/' + @atn['user_id'].to_s + '?width=105'
      @avatar_view.setImageWithURL(NSURL.URLWithString(url), placeholderImage: UIImage.imageNamed('default-avatar.png'))
      @avatar_view.contentMode = UIViewContentModeScaleAspectFill
      @avatar_view.layer.masksToBounds = true
      @avatar_view.layer.cornerRadius = 17
      @avatar_view

      bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, rect.size.width, rect.size.height), cornerRadius: 0.0)
      '#FCFCF3'.uicolor.setFill
      bgPath.fill

      name = @name.attrd(NSFontAttributeName => Font.Karla_Italic(13), UITextAttributeTextColor => Color.dark_gray)
      nameBox = name.boundingRectWithSize(rect.size, options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
      name.drawInRect(CGRectMake(rect.size.width / 2 - nameBox.size.width / 2, rect.size.height - 18, Float::MAX, Float::MAX))

      
    end
  end
end

class ChatterDots < UIView
  def setAdmin(admin)
    @admin = admin
    self.setNeedsDisplay
  end
  def drawRect(rect)
    width = rect.size.width - 2
    height = rect.size.height - 2

    bgPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(0, 0, width, height), cornerRadius: 3.0)
    "#F7F7F1".uicolor.setFill
    bgPath.fill
    iconPath = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(2, 2, width - 4, height - 4), cornerRadius: 2.0)
    if @admin.nil? || !@admin
      "#B6B6AA".uicolor.setFill
    elsif @admin
      Color.orange.setFill
    end
    iconPath.fill
    dot1 = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(rect.size.width - 2 - 8, 6, 3, 3), cornerRadius: 3.0)
    dot2 = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(rect.size.width - 2 - 13, 6, 3, 3), cornerRadius: 3.0)
    dot3 = UIBezierPath.bezierPathWithRoundedRect(CGRectMake(rect.size.width - 2 - 18, 6, 3, 3), cornerRadius: 3.0)
    "#F7F7F1".uicolor.setFill
    dot1.fill
    dot2.fill
    dot3.fill
  end
end

class ChattersHorizontalCollection < ProMotion::CollectionScreen
  collection_layout UICollectionViewFlowLayout,
                    direction:                 :horizontal,
                    minimum_line_spacing:      0,
                    minimum_interitem_spacing: 0,
                    item_size:                 [64, 64],
                    section_inset:             [0, 0, 0, 0]

  cell_classes cell: ChattersHorizontalCell

  def viewDidLoad
    super
    self.view_did_load if self.respond_to?(:view_did_load)
    @items = []
    @cells = []
    itemData
    self.collectionView.backgroundColor = UIColor.clearColor
    self.collectionView.bounces = true
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false
    self.collectionView.alwaysBounceHorizontal = true
  end
  def setLayout(layout)
    @admins = []
    @layout = layout
  end
  def setAdmins(admins)
    @admins = admins
    reload_data
  end
  def select_atn(atn)
    @layout.select_atn(atn)
  end
  def setChatters(chatters)
    @items = chatters
    # update_collection_view_data(collection_data, { index_paths: [NSIndexPath.indexPathForRow(@items.length -1, inSection:0)] })
    # self.collectionView.reloadItemsAtIndexPaths(self.collectionView.indexPathsForVisibleItems);
    if @items.length > 1
      UIView.setAnimationsEnabled(false)
    end
    reload_data
    if @items.length > 1
      0.1.seconds.later do
        UIView.setAnimationsEnabled(true)
      end
    end
    # # UIView.performWithoutAnimation -> {
    # #   self.collectionView.reloadSections(NSIndexSet.indexSetWithIndex(0))
    # # }
  end
  def isAdmin(atn)
    @admins.include?(atn['user_id'])
  end
  def itemData
    items = @items
    if items.length > 0
      @cells = [
        items.map do |atn|
          {
            atn: atn,
            admin: isAdmin(atn),
            cell_identifier: :cell,
            controller: self,
            arguments: [ atn: atn, admin: isAdmin(atn) ]
          }
        end
      ]
    else
      @cells = []
    end
    @cells
  end
  def collection_data
    itemData
  end
  def remove_action(atn)
    @layout.remove(atn)
  end
end


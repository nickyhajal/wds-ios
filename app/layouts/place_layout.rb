# This helped with the map: http://www.devfright.com/mkpointannotation-tutorial/
class PlaceLayout < MK::Layout
  include MapKit
  def setController(controller)
    @controller = controller
  end
  def updatePlace(place, updateMap = true)
    @updateMap = updateMap
    @place = place
    self.reapply!
    0.05.seconds.later do
      updateScrollSize
    end
  end
  def layout
    root :main do
      add MapView, :map
      add UIView, :main_content do
        add UIView, :map_line_bot
        add UIScrollView, :scrollview do
          add UITextView, :name
          add UITextView, :address
          add UIView, :line
          add HTMLTextView, :descr
          add UIView, :anchor
        end
        add UIView, :pan_catch
      end
    end
  end
  def super_height
    get(:main).frame.size.height
  end
  def super_width
    get(:main).frame.size.width
  end
  def main_style
    background_color Color.light_tan
  end
  def main_content_style
    constraints do
      @scrollview_top = top 266
      @scrollview_height = height super_height-266
      left 0
      width super_width
    end
  end
  def map_line_bot_style
    constraints do
      top 0
      left 0
      width.equals(:superview)
      @map_line_height = height 4
    end
    backgroundColor "#848477".uicolor(0.1)
  end
  def map_style
    constraints do
      width.equals(:superview)
      height 204
      top 64
      left 0
    end
    delegate self
    reapply do
      if !@place[:lat].nil? && !@place[:lon].nil? && @updateMap
        @updateMap = false
        target.region = CoordinateRegion.new([@place[:lat].to_f+0.0004, @place[:lon]], [0.1, 0.1])
        target.set_zoom_level(15)
        target.removeAnnotations(target.annotations)
        pin = MKPointAnnotation.alloc.init
        pin.coordinate = CLLocationCoordinate2DMake(@place[:lat], @place[:lon])
        pin.title = @place[:name]
        pin.subtitle = @place[:address].gsub(/, Portland[\,]? OR[\s0-9]*/, '')
        target.addAnnotation pin
      end
    end
  end
  def address_style
    font Font.Karla(16)
    textColor Color.coffee
    reapply do
      txt = ''
      text @place[:address].gsub(/, Portland[\,]? OR[\s0-9]*/, '')
    end
    constraints do
      @place_top = top.equals(:name, :bottom).minus(15)
      width.equals(:superview)
      height 30
      left.equals(:line)
    end
  end
  def line_style
    backgroundColor Color.light_gray
    constraints do
      left 15
      width.equals(:name)
      height 6
      top.equals(:address, :bottom).plus(7)
    end
  end
  def scrollview_style
    scrollEnabled true
    delegate self
    contentSize [super_width, 900]
    backgroundColor Color.white
    constraints do
      top 4
      height.equals(:main_content).minus(4)
      left 0
      width.equals(:superview)
    end
  end
  def descr_style
    constraints do
      top.equals(:line, :bottom).plus(4)
      left.equals(:line).minus(4)
      @descr_height = height 40
      width.equals(:line)
    end
    textView = target
    target.scrollView.scrollEnabled = false
    backgroundColor Color.clear
    reapply do
      if !@place[:descr].nil? && @place[:descr].length > 0
        text = @place[:descr]
        str = text.attrd({
          NSFontAttributeName => Font.Karla(15)
        })
        rect = str.boundingRectWithSize(CGSizeMake(super_width-24,Float::MAX), options: NSStringDrawingUsesLineFragmentOrigin, context: nil)
        height = rect.size.height.ceil + 60
        @descr_height.equals(height)
        textView.setText @place[:descr]
      end
    end
  end
  def pan_catch_style
    constraints do
      width.equals(:main_content)
      height.equals(:main_content)
      top 0
      left 0
    end
    view = target
    target.on_tap do |gesture|
      x = gesture.locationInView(get(:superview)).x
      y = gesture.locationInView(get(:superview)).y
      if (!@slid_open && y > 392 && y < 423) || (@slid_open && y > 181 && y < 212)
      end
    end
    target.on_pan do |gesture|
      @slid_up.nil?
      y = gesture.locationInView(get(:superview)).y
      if gesture.state == UIGestureRecognizerStateBegan
        @startPan = y
        @lastPan = @startPan
      end
      if gesture.state == UIGestureRecognizerStateEnded
        if @slid_open.nil?
          if @startPan - y > 40
            slideOpen
          else
            slideClosed
          end
        else
          if (@startPan - y) < -30
            slideClosed
          else
            @slid_open = nil
            slideOpen
          end
        end
        @startPan = false
      end
      if @startPan
        diff = @startPan - y
        lastDiff = @lastPan - y
        @lastPan = y
        if @slid_open.nil?
          if diff > 0
            shiftContent lastDiff
          end
          if diff > 50
            slideOpen
          end
        else
          if diff < 0
            shiftContent lastDiff
          end
          if diff < -50
            slideClosed
          end
        end
      end
    end
  end
  def name_style
    constraints do
      top 10
      left 12
      @name_height = height 0
      width.equals(:superview).minus(40)
    end
    font Font.Vitesse_Medium(26)
    textColor "#0A72B0".uicolor
    fixedWidth = super_width-40
    textView = target
    scrollEnabled false
    editable false
    backgroundColor UIColor.clearColor
    reapply do
      text @place[:name]
      newSize =  textView.sizeThatFits(CGSizeMake(fixedWidth, Float::MAX))
      @name_height.equals(newSize.height+5)
    end
  end
  def anchor_style
    constraints do
      height 1
      top.equals(:descr, :bottom)
      width.equals(:superview)
      left 0
    end
  end
  def slideOpen(speed = 0.2)
    if @slid_open.nil?
      @slid_open = true
      @scrollview_top.equals(56)
      @scrollview_height.equals(super_height-56)
      @map_line_height.equals(0)
      UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
        self.view.layoutIfNeeded  # applies the constraint change
      end, completion: nil)
      if @contentHeight > (super_height - 60)
        get(:pan_catch).setHidden true
      end
    end
  end
  def slideClosed(speed = 0.2)
    @slid_open = nil
    @scrollview_top.equals(266)
    @scrollview_height.equals(super_height-266)
    @map_line_height.equals(4)
    UIView.animateWithDuration(speed, delay: 0.0, options: UIViewAnimationOptionCurveEaseIn, animations: -> do
      self.view.layoutIfNeeded  # applies the constraint change
    end, completion: nil)
    get(:pan_catch).setHidden false
  end
  def shiftContent(shift)
    @scrollview_top.minus(shift)
    @scrollview_height.plus(shift)
  end
  def updateScrollSize
      frame = get(:anchor).frame
      bot_padding = 50
      height = frame.origin.y + frame.size.height + bot_padding
      @contentHeight = height
      get(:scrollview).setContentSize([super_width, height])
  end

  ## ScrollView Delegate
  def scrollViewDidScroll(scrollView)
    y = scrollView.contentOffset.y
    if y < -20
      slideClosed
    end
  end

  ## MapView delegate
  def mapView(mapView, didAddAnnotationViews:views)MKPointAnnotation
    mapView.selectAnnotation(mapView.annotations.lastObject, animated:true)
  end
  def mapView(mapView, viewForAnnotation:annotation)
    if annotation.class.to_s.include?('MKPointAnnotation')
      pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("LocationView")
      if pinView
        pinView.annotation = annotation
      else
        pinView = MKAnnotationView.alloc.initWithAnnotation(annotation, reuseIdentifier:"LocationView")
        pinView.canShowCallout = true
        rightButton = UIButton.alloc.initWithFrame(CGRectMake(0,0,40,40))
        rightButton.addTarget @controller, action:'go_to_directions_action', forControlEvents:UIControlEventTouchDown
        rightButton.setImage(Ion.imageByFont(:ios_navigate, size:24.5, color:"#B0BA1E".uicolor), forState:UIControlStateNormal)
        pinView.rightCalloutAccessoryView = rightButton
      end
      pinView
    else
      nil
    end
  end
end
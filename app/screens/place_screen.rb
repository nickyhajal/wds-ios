class PlaceScreen < PM::Screen
  title "Place"
  status_bar :dark
  def on_init
    @from = false
    @layout = PlaceLayout.new(root: self.view)
    @place = false
    @layout.setController self
    @layout.build
  end
  def on_load
    true
  end
  def setPlace(place)
    @place = place
    title = @place[:name]
    if title.length > 12
      title = title[0..11]+'...'
    end
    self.title = title
    @layout.slideClosed(0.0)
    @layout.updatePlace @place
  end
  def back_action
    close_screen
  end
  def go_to_directions_action
    chrome = "comgooglemaps://"
    chromeURL = NSURL.URLWithString(chrome)
    lat = @place[:lat].to_s
    lon = @place[:lon].to_s
    destination = lat+','+lon
    if UIApplication.sharedApplication.canOpenURL(chromeURL)
      UIApplication.sharedApplication.openURL(NSURL.URLWithString(chrome+'?daddr='+destination+'&directionsmode=walking'))
    else
      place = MKPlacemark.alloc.initWithCoordinate(CLLocationCoordinate2DMake(lat, lon), addressDictionary: nil)
      item = MKMapItem.alloc.initWithPlacemark(place)
      item.setName(@place[:name])
      currentLocationMapItem = MKMapItem.mapItemForCurrentLocation
      launchOptions = {
        MKLaunchOptionsDirectionsModeKey => MKLaunchOptionsDirectionsModeWalking
      }
      MKMapItem.openMapsWithItems([currentLocationMapItem, item], launchOptions: launchOptions)
    end
  end
  def shouldAutorotate
    false
  end
end
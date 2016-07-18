class CartScreen < PM::Screen
  status_bar :dark
  attr_accessor :controller, :layout, :dispatch
  def on_init
    @layout = CartLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    @code = false
    @meta = false
    @syncCard = false
  end
  def init_layout
    # @layout.get(:input).layoutIfNeeded
  end
  def will_appear
    # @layout.get(:card_num).becomeFirstResponder
    # @layout.get(:card_num).layoutIfNeeded
  end
  def setProduct(code, meta)
    @code = code
    @meta = meta
    updateCart
  end
  def updateCart
    pkg = {}
    if @code == 'academy'
      pkg = {
        name: "WDS Academy",
        descr: @meta.what,
        price: "29"
      }
      @purchase_data = {
        event_id: @meta.event_id
      }
    end
    @layout.updateVals(pkg)
  end
  def purchase_action
    if (@layout.useExisting)
      charge(@layout.card[:hash])
    else
      card_num = @layout.get(:card_num).text
      card_cvv = @layout.get(:card_cvv).text
      month = @layout.month
      year = @layout.year
      card = STPCardParams.new
      card.number = card_num
      card.cvc = card_cvv
      card.expMonth = month
      card.expYear = year
      STPAPIClient.sharedClient.createTokenWithCard(card, completion: -> rsp, err {
        if err.nil? and !rsp.nil? and !rsp.tokenId.nil?
          charge(rsp.tokenId)
          @syncCard = true # If this card charges, we want it for future purchases within app
        else
          handleErrors(err)
        end
      })
    end
    # @layout.get(:input).resignFirstResponder
  end
  def handleErrors(errs)
  end
  def charge(token)
    puts 'charge'
    puts token
    params = {
      card_id: token,
      purchase_data: @purchase_data,
      code: @code
    }
    Api.post "product/charge", params do |rsp|
      puts rsp
      if rsp.is_err
        $APP.offline_alert
      elsif !rsp.json['declined'].nil?
        puts 'declined'
      else
        puts 'success!'
        if @syncCard
          @layout.syncCard
          @syncCard = false
        end
      end
    end
  end
  def close_action
    # @layout.get(:input).resignFirstResponder
    0.2.seconds.later do
      close_screen
      UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
    end
  end
  def shouldAutorotate
    false
  end
end
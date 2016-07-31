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
    @purchasedCallback = false
  end
  def onCapture
    scanViewController = CardIOPaymentViewController.alloc.initWithPaymentDelegate(self)
    scanViewController.hideCardIOLogo = true
    scanViewController.guideColor = Color.orange
    scanViewController.navigationBarTintColor = Color.green
    scanViewController.keepStatusBarStyle = true
    # scanViewController.appToken = # fill in
    self.presentModalViewController(scanViewController, animated:true)
  end
  def userDidCancelPaymentViewController(scanViewController)
    # NSLog("User canceled payment info")
    scanViewController.dismissModalViewControllerAnimated(true)
  end
  def userDidProvideCreditCardInfo(info, inPaymentViewController:scanViewController)
    # NSLog("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
    @layout.get(:card_cvv).text = info.cvv.to_s
    @layout.get(:card_num).text = info.cardNumber.to_s
    @layout.setMonth(info.expiryMonth.to_s)
    @layout.setYear(info.expiryYear.to_s)
    scanViewController.dismissModalViewControllerAnimated(true)
  end
  def setPurchasedCallback(owner, method, meta)
    @purchasedCallback = {
      owner: owner,
      method: method,
      meta: meta
    }
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
    elsif @code == 'wds2017'
      pkg = {
        name: "WDS 2017",
        descr: "360 Ticket to WDS 2017",
        price: "547",
        confirm: true,
        max_quantity: 3
      }
      @purchase_data = {
        quantity: 1
      }
    end
    @layout.updateVals(pkg)
  end
  def change_quantity_action
    quantity = @layout.get(:item_q).selectedSegmentIndex + 1
    @purchase_data[:quantity] = quantity
    @layout.setQuantity(quantity)
  end
  def confirm_action(item)
    purchase_action true
    @layout.get(:modal).close
  end
  def purchase_action(confirmed = false)
    if confirmed.class.to_s.include?('UIButton')
      confirmed = false
    end
    if @layout.vals[:confirm] and !confirmed
      q = @layout.vals[:quantity]
      if q == 1
        tickets = "1 ticket to WDS 2017"
      else
        tickets = q.to_s+" tickets to WDS 2017"
      end
      str = "Just to double-check, you'll be charged: "+@layout.get(:item_price).text
      str += " for "+tickets+".\n\nSound good?"
      modal = {
        title: 'Confirm Purchase',
        content: str,
        close_on_yes: true,
        yes_text: "Let's Do This!",
        no_text: "Nevermind",
        yes_action: 'confirm_action',
        controller: self
      }
      @layout.get(:modal).open(modal)
    else
      if !@layout.charging
        @layout.charging = true
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
          @layout.status = "validating"
          STPAPIClient.sharedClient.createTokenWithCard(card, completion: -> rsp, err {
            if err.nil? and !rsp.nil? and !rsp.tokenId.nil?
              charge(rsp.tokenId)
              @syncCard = true # If this card charges, we want it for future purchases within app
            else
              @layout.charging = false
              handleErrors(err)
            end
          })
        end
      end
    end
  end
  def handleErrors(err)
    @layout.status = "error"
    msg = err.localized
    modal = {
      title: 'There was a problem.',
      content: "Looks like there was a problem:

#{msg}

Can you try again?",
      close_on_yes: true,
      hide_no: true,
      yes_text: 'Ok',
      controller: self
    }
    @layout.get(:modal).open(modal)
    5.0.seconds.later do
      @layout.status = "waiting"
    end
  end
  def charge(token)
    params = {
      card_id: token,
      purchase_data: @purchase_data,
      via: 'ios',
      code: @code
    }
    @layout.status = "processing"
    Api.post "product/charge", params do |rsp|
      if rsp.is_err
        @layout.charging  = false
        $APP.offline_alert
      elsif !rsp.json['declined'].nil?
        @layout.charging  = false
        @layout.status = "error"
        modal = {
          title: 'There was a problem.',
          content: "Looks like there was a problem. Can you try again? If
          you continue to have trouble, please try another card.",
          close_on_yes: true,
          hide_no: true,
          yes_text: 'Ok',
          controller: self
        }
        5.0.seconds.later do
          @layout.status = "waiting"
        end
        @layout.get(:modal).open(modal)
      else
        @layout.status = "success"
        if @purchasedCallback
          pc = @purchasedCallback
          if pc[:meta]
            pc[:owner].send(pc[:method], pc[:meta])
          else
            pc[:owner].send(pc[:method])
          end
          @purchasedCallback = false
        end
        1.0.seconds.later do
          self.close_screen
        end
        5.0.seconds.later do
          @layout.charging  = false
          @layout.status = "waiting"
        end
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
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
    @ref = false
    @purchasedCallback = false
  end
  def onCapture
    scanViewController = CardIOPaymentViewController.alloc.initWithPaymentDelegate(self)
    scanViewController.hideCardIOLogo = true
    scanViewController.guideColor = Color.orange
    scanViewController.navigationBarTintColor = Color.green
    scanViewController.keepStatusBarStyle = true
    self.presentModalViewController(scanViewController, animated:true)
  end
  def userDidCancelPaymentViewController(scanViewController)
    scanViewController.dismissModalViewControllerAnimated(true)
  end
  def userDidProvideCreditCardInfo(info, inPaymentViewController:scanViewController)
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
  def setTerms(terms)
    @layout.setTerms(terms)
  end
  def updateCart
    pkg = {}
    if @code == 'academy' || @code == 'event'
      name = "WDS #{EventTypes.byId(@meta.type)[:single]}"
      price = @code == 'academy' ? '29' : "#{@meta.price/100}"
      pkg = {
        name: name,
        descr: @meta.what,
        price: price
      }
      @purchase_data = {
        event_id: @meta.event_id
      }
    elsif @code == 'wds2019'
      pkg = {
        name: "WDS 2019",
        descr: "360 Ticket to WDS 2019",
        price: "597",
        confirm: true,
        max_quantity: 3,
        fee: 10
      }
      @purchase_data = {
        quantity: 1
      }
    elsif @code == 'wdsDouble'
      pkg = {
        name: "WDS 2019 & 2020",
        descr: "360 Ticket to WDS 2019 & 2020",
        price: "997",
        confirm: true,
        max_quantity: 3,
        fee: 10
      }
      @purchase_data = {
        quantity: 1
      }
    elsif @code == 'wds2018'
      pkg = {
        name: "WDS 2018",
        descr: "360 Ticket to WDS 2018",
        price: "547",
        confirm: true,
        max_quantity: 3,
        fee: 10
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
    @layout.get(:modal).close
    purchase_action true
  end
  def purchase_action(confirmed = false)
    if confirmed.class.to_s.include?('UIButton')
      confirmed = false
    end
    if @layout.vals[:confirm] and !confirmed
      q = @layout.vals[:quantity]
      if @code === 'wdsDouble'
        if q == 1
          tickets = "1 ticket to WDS 2019 & 2020"
        else
          tickets = q.to_s+" tickets to WDS 2019 & 2020"
        end
      elsif @code === 'wds2019'
        if q == 1
          tickets = "1 ticket to WDS 2019"
        else
          tickets = q.to_s+" tickets to WDS 2019"
        end
      end
      priceStr = @layout.get(:item_price).text
      priceStr = priceStr.sub('$', '')
      price = (priceStr.to_i + (10*q)).to_s
      str = "Just to double-check, you'll be charged $#{price}"
      str += " for "+tickets+" (including a $10 processing fee"
      if q > 1
        str += " per ticket"
      end
      str += ").\n\nSound good?"
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
  def showError(title, content)
    unwatch
    @layout.charging  = false
    @layout.status = "error"
    modal = {
      title: title,
      content: content,
      close_on_yes: true,
      hide_no: true,
      yes_text: 'Ok',
      controller: self
    }
    5.0.seconds.later do
      @layout.status = "waiting"
    end
    @layout.get(:modal).open(modal)
  end
  def charge(token)
    params = {
      card_id: token,
      purchase_data: @purchase_data,
      via: 'ios',
      code: @code
    }
    @layout.status = "authorizing"
    Api.post "product/charge", params do |rsp|
      if rsp.is_err || rsp.fire.nil?
        showError('There was a problem.', "Looks like there was a problem. Can you try again?\n\nIf
          you continue to have trouble, please try another card.")
      elsif !rsp.json['declined'].nil?
        showError('There was a problem.', "Looks like there was a problem. Can you try again?\n\nIf
          you continue to have trouble, please try another card.")
      else
        path = "/sales/#{@code}/#{rsp.fire}"
        @ref = Fire.watch 'value', path do |charge|
          unless charge.nil? or charge.value.nil?
            status = charge.value[:status]
            if status == 'pre-process'
              @layout.status = "processing"
            elsif status == 'stripe-charge'
              @layout.status = "charging"
            elsif status == 'error'
              @layout.status = "charging"
              showError('There was a problem.', "Hm, it looks like your card was declined for some reason.\n\nCan you double-check and try again or try another card?")
            elsif status == 'done'
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
      end
    end
  end
  def unwatch
    if @ref
      Fire.unwatch @ref
      @ref = false
    end
  end
  def close_action
    unwatch
    0.2.seconds.later do
      close_screen
      UIApplication.sharedApplication.setStatusBarStyle(UIStatusBarStyleLightContent)
    end
  end
  def shouldAutorotate
    false
  end
end
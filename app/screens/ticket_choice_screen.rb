class TicketChoiceScreen < PM::Screen
  attr_accessor :layout, :controller
  title "Ticket Choice"
  status_bar :light
  nav_bar true
  nav_bar_button :left, title: "x", action: :close_action
  def on_load
    @state = false
    @cart = CartScreen.new(nav_bar: true)
    @layout = TicketChoiceLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    # 0.5.seconds.later do
    #   @layout.updateScrollSize
    # end
    true
  end
  def tckt_purchased
    @controller.tckt_purchased
    0.9.seconds.later do
      close
    end
  end
  def updateState
    unless @layout.nil?
      @layout.reapply!
    end
  end
  def single_buy_action
    @cart.setProduct('wds2019', {})
    @cart.setPurchasedCallback(self, 'tckt_purchased', false)
    @cart.setTerms('Each ticket includes 1 complimentary, non-transferable WDS Academy, priority booking at the WDS Hotel, and other discounts and benefits.

Tickets are non-refundable. Name changes and ticket transfers are permitted up to 30 days prior to the event for a $100 fee. A late transfer option will be available at a higher cost.')
    open @cart
  end
  def double_buy_action
    @cart.setProduct('wdsDouble', {})
    @cart.setPurchasedCallback(self, 'tckt_purchased', false)
    @cart.setTerms('Each ticket includes 1 complimentary, non-transferable WDS Academy, priority booking at the WDS Hotel, and other discounts and benefits.

Tickets are non-refundable. Name changes and ticket transfers are permitted up to 30 days prior to the event for a $100 fee. A late transfer option will be available at a higher cost.')
    open @cart
  end
  def close_action
    close
  end
  def shouldAutorotate
    false
  end
end
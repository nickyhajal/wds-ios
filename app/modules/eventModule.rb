module EventModule
  def on_load
  end
  def types
    {
      meetup: {
        title: 'Meetups',
        single: 'Meetup'
      },
      # spark_session: {
      #   title: 'Spark Sessions',
      #   single: 'Spark Session'
      # },
      academy: {
        title: 'Academies',
        single: 'Academy'
      },
      activity: {
        title: 'Activities',
        single: 'Activity'
      },
      # expedition: {
      #   title: 'Expeditions',
      #   single: 'Expedition'
      # },
      registration: {
        title: 'Registration',
        single: 'Registrations'
      },
    }
  end
  def pluralToType
    {
      activities: 'activity',
      meetups: 'meetup',
      # expeditions: 'expedition',
      spark_sessions: 'spark_session',
      registration: 'registration',
      academies: 'academy'
    }
  end
  def confirmModal(event)
    unless @event.nil?
      event = @event
    end
    type = types[event.type.to_sym][:single]
    typelow = type.downcase
    typeplural = types[event.type.to_sym][:title]
    if event.type == 'registration'
      if Me.isAttendingEvent event
        modal = {
          item: event,
          title: "Can't make it?",
          content: "Not able to make it to this registration time? No problem.
          
Just cancel your RSVP below.

Please signup for another registration time so we can have things ready for you!
          ",
          yes_action: 'doRsvp',
          yes_text: 'Cancel RSVP',
          controller: self
        }
      else
        modal = {
          item: event,
          title: "Register at this Time!",
          content: "By RSVPing for a registration time, we can make sure the process goes quickly and smoothly for everyone.

Will you make it this registration time?
          ",
          yes_action: 'doRsvp',
          yes_text: 'Yep, let\'s do it!',
          controller: self
        }
      end
    elsif event.type == 'academy'
      if !Me.claimedAcademy and event.hasClaimableTickets
        modal = {
          item: event,
          title: 'Attend this Academy!',
          content: "WDS Attendees may claim one complimentary
          academy and purchase additional academies for $29.

Would you like to claim this ticket? (You can't change this later)",
          close_on_yes: false,
          yes_action: 'claimAcademy',
          yes_text: 'Claim Academy',
          no_text: 'No, thanks.',
          controller: self
        }
      elsif !Me.claimedAcademy and !event.hasClaimableTickets
        modal = {
          item: event,
          title: 'Attend this Academy!',
          content: "You still have 1 free academy to claim but unfortunately
          there are no more insider access tickets available for this academy.

You can still purchase a ticket for $29.",
          yes_action: 'purchase',
          yes_text: 'Purchase',
          no_text: 'No, thanks.',
          controller: self
        }
      else
        modal = {
          item: event,
          title: 'Attend this Academy!',
          content: "WDS Academies cost $59 but WDS Attendees
          can get access for just $29.

Would you like to purchase this academy?",
          disclaimer: "Note: #{typeplural} can't be refunded or transferred.",
          yes_action: 'purchase',
          yes_text: 'Purchase',
          no_text: 'No, thanks.',
          controller: self
        }
      end
    else
      if Me.isAttendingEvent event
        modal = {
          item: event,
          title: "Can't make it?",
          content: "Not able to make it to this #{typelow}? No problem.

Just cancel your RSVP below to make space for other attendees.
          ",
          yes_action: 'doRsvp',
          yes_text: 'Cancel RSVP',
          controller: self
        }
      else
        if !event.price.nil? and event.price > 0
          price = "$#{event.price / 100}"
          if event.pay_link.length > 0
            modal = {
              item: event,
              title: "Attend this #{type}!",
              content: "Attending this event costs #{price}.

In this case, payment is processed externally, so you'll temporarily leave the WDS App to complete your purchase.

Would you like to purchase access to this #{type}?",
              disclaimer: "Note: #{typeplural} can't be refunded or transferred.",
              yes_action: 'goToLink',
              yes_text: "Let's do it!",
              no_text: 'Close',
              controller: self
            }
          else
            modal = {
              item: event,
              title: "Attend this #{type}!",
              content: "Attending this event costs #{price}.

Would you like to purchase access to this #{type}?",
              yes_action: 'purchase',
              disclaimer: "Note: #{typeplural} can't be refunded or transferred.",
              yes_text: "Let's do it!",
              no_text: 'No, thanks.',
              controller: self
            }
          end
        else
          modal = {
            item: event,
            title: 'See you there?',
            content: "This #{typelow} will be on #{event.dayStr} at #{event.startStr}.

  Please only RSVP if you're sure you will attend.
            ",
            yes_action: 'doRsvp',
            yes_text: 'Confirm RSVP',
            controller: self
          }
        end
      end
    end
    modal
  end
  def goToLink(event)
    UIApplication.sharedApplication.openURL(event.pay_link.nsurl)
  end
  def purchase(event)
    @cart ||= CartScreen.new(nav_bar: false)
    product = event.type == 'academy' ? 'academy' : 'event'
    @cart.setProduct(product, event)
    @cart.setPurchasedCallback(self, 'purchaseComplete', event)
    closeModal
    open_modal @cart
  end
  def purchaseComplete(event)
    Me.addRsvp(event.event_id)
    if !@activeCell.nil?
      @activeCell.setNeedsDisplay
    else
      @layout.reapply!
    end
  end
end 
class WalkthroughScreen < PM::Screen
  status_bar :light
  def on_load
    @finished = false
    @layout = WalkthroughLayout.new(root: self.view)
    @layout.setController self
    @layout.build
    true
  end
  def on_appear
    0.05.seconds.later do
      @layout.fade_in
      unless @step.nil?
        goToStep
      end
    end
  end
  def setStep(step)
    @step = step
  end
  def goToStep
    @layout.goToStep @step
  end
  def finish_action
    unless @finished
      @finished = true
      @layout.fade_out
      0.3.seconds.later do
        $APP.open_login
      end
    end
  end
  def shouldAutorotate
    false
  end
end
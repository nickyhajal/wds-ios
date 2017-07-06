class ExpirationPicker < UIPickerView
  attr_accessor :controller
  def initWithFrame(frame)
    # self.setShowSelectionIndicator true
    self.setDataSource self
    self.setDelegate self
    @months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
    @years = [
      '2017', '2018', '2019', '2020', '2021', '2022',
      '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030'
    ]
    @components = [@months, @years]
    @selected = 0
    super
  end
  def pickerView(pickerView, numberOfRowsInComponent:component)
    @components[component].length
  end
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    @components[component][row]
  end
  def numberOfComponentsInPickerView (pickerView)
    2
  end
  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    unless @controller.nil?
      month = @components[0][self.selectedRowInComponent(0)]
      year = @components[1][self.selectedRowInComponent(1)]
      @controller.updateExp(month, year)
    end
  end
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    @components[component][row]
  end
end
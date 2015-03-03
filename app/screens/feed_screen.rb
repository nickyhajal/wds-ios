class FeedScreen < PM::Screen
  title 'Dispatch'
  status_bar :light
  attr_accessor :layout
  def on_load
    @layout = FeedLayout.new(root: self.view)
    @results_table = AttendeeSearchResults.new
    @layout.results_view = @results_table.view
    @layout.setResultsTable @results_table
    @layout.setController self
    @layout.build
    true
  end
end
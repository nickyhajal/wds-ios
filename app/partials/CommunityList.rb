class CommunityList < PM::TableScreen
  title "CommunityList"
  row_height 50
  def setController(controller)
    @controller = controller
  end
  def on_load
    @items = []
    self.tableView.setSeparatorStyle(UITableViewCellSeparatorStyleNone)
    self.tableView.backgroundView = nil
    self.tableView.backgroundColor = "#F2F2EA".uicolor
  end
  def setLayout(layout)
    @layout = layout
  end
  def table_data
    [{cells: @items}]
  end
  def clear
    @items = []
    update_table_data
  end
  def make_cell(item)
    {
      title: '',
      cell_class: CommunityCell,
      action: :select_community_action,
      arguments: { community: item},
      properties: {
        selectionStyle: UITableViewCellSelectionStyleNone,
        community: Interest.new(item),
        width: @width,
        controller: self
      }
    }
  end
  def update_from_store
    communities = Assets.get('interests')
    update(communities)
  end
  def update(items)
    isTop = true
    joined = []
    not_joined = []
    items.each do |item|
      cell = make_cell item
      if Me.isInterested(item[:interest_id])
        joined << cell
      else
        not_joined << cell
      end
    end
    @items = joined + not_joined
    update_table_data
  end
  def select_community_action(community)
    @controller.select_community_action(community)
  end
end
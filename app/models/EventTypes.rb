module EventTypes
  class << self
    def types(form = 'id')
      ['meetup', 'spark_session', 'academy', 'activity']
    end
    def byId(id = 'meetup')
      out = false
      EventTypes.list.each do |type|
        if type[:id] == id
          out = type
        end
      end
      out
    end
    def list
      list = []
      list << {
        title: 'Meetups',
        single: 'Meetup',
        id: 'meetup',
        plural: 'Meetups'
      }
      list << {
        id: 'spark_session',
        title: 'Spark Sessions',
        single: 'Spark Session',
        plural: 'Spark Sessions'
      }
      list << {
        id: 'academy',
        title: 'Academies',
        single: 'Academy',
        plural: 'Academies'

      }
      list << {
        id: 'activity',
        title: 'Activities',
        single: 'Activity',
        plural: 'Activities'
      }
      list
    end
  end
end
module EventTypes
  class << self
    def types(form = 'id')
      # ['meetup', 'academy', 'activity', 'expedition', 'registration']
      ['meetup', 'academy', 'activity', 'registration', 'ambassador']
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
      # list << {
      #   id: 'spark_session',
      #   title: 'Spark Sessions',
      #   single: 'Spark Session',
      #   plural: 'Spark Sessions'
      # }
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
      # list << {
      #   id: 'expedition',
      #   title: 'Expeditions',
      #   single: 'Expedition',
      #   plural: 'Expeditions'
      # }
      list << {
        id: 'registration',
        title: 'Registration',
        single: 'Registration',
        plural: 'Registration'
      }
      list << {
        id: 'ambassador',
        title: 'Ambassador',
        single: 'Ambassador',
        plural: 'Ambassador'
      }
      list
    end
  end
end
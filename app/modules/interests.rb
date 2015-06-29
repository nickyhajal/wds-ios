module Interests
  class << self
    def init
      interests = Store.get('interests', true)
      if interests
        updateInterests interests
      end
    end
    def updateInterests(interests)
      @interests = []
      @interestsById = {}
      interests.each do |int|
        int = Interest.new int
        @interests << int
        @interestsById[int.interest_id.to_s] = int
      end
    end
    def interestById(id)
      @interestsById[id.to_s]
    end
  end
end
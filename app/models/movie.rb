class Movie < ActiveRecord::Base
    # define the class method to return the checkbox options
    def self.all_ratings
        return ['G','PG','PG-13','R']
    end
end

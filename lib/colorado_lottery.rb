class ColoradoLottery
  attr_reader :registered_contestants, :winners, :current_contestants
  def initialize
    @registered_contestants = {}
    @winners = []
    @current_contestants = {}
  end

  def interested_and_18?(contestant, game)
     contestant.game_interests.include?(game.name) && at_least_18?(contestant)
  end

  def at_least_18?(contestant)
    contestant.age >= 18
  end

  def can_register?(contestant, game)
    if interested_and_18?(contestant, game) && local_register?(contestant, game)
        true
    elsif interested_and_18?(contestant, game) && game.national_drawing?
        true
      else
        false
    end
  end

  def local_register?(contestant, game)
    if interested_and_18?(contestant, game) == true
      if game.national_drawing? == false && contestant.out_of_state? == false
        true
      else
        false
      end
    end
  end

  def register_contestant(contestant, game)
    if can_register?(contestant, game)
      if @registered_contestants.keys.include?(game.name)
      @registered_contestants[game.name] << contestant
    else
      @registered_contestants[game.name] = [contestant]
      end
    end
  end

  def eligible_contestants(game)
    eligible = @registered_contestants[game.name]
    eligible.find_all do |contestant|
      contestant.spending_money > game.cost
    end
  end

  def charge_contestants(game)
    contestants = eligible_contestants(game).map do |contestant|
        "#{contestant.first_name} #{contestant.last_name}"
      end
      @current_contestants[game] = contestants

    # charge = eligible_contestants(game).map do |contestant|
    #   (contestant.spending_money -= game.cost)
    # end
    # charge
  end
end

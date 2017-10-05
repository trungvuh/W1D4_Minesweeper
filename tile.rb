class Tile

  attr_reader :contains_bomb, :flagged_state, :guessed_state,
  :bombs_around_me

  attr_writer :bombs_around_me

  def initialize(bomb_boolean)
    @bombs_around_me = 0
    @contains_bomb = bomb_boolean
    @guessed_state = false
    @flagged_state = false
  end

  def be_guessed
    @guessed_state = true
  end

  def be_flagged
    @flagged_state = true
  end

  def unflag
    @flagged_state = false
  end

  def to_s
    if @flagged_state
      p 'f'
    elsif guessed_state == false
      p '*'
    else
      if @bombs_around_me == 0
        p '_'
      elsif @contains_bomb == false
        p "#{bombs_around_me}"
      else
        p 'b'
      end
    end
  end

end

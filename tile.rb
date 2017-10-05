class Tile

  def initialize(bomb_boolean)
    @bombs_around_me = 0
    @contains_bomb = bomb_boolean
    @guessed_state = false
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

class Game

  def initialize(board)
    @board = board
  end

  def win?

  end

  def lose?

  end

  def valid_pos?(pos)
    pos.is_a?(Array) &&
      pos.length == 2 &&
      pos[0].between?(0, board.height) &&
      pos[1].between?(0, board.width)
  end

  def parse_pos(string)
    string.split(",").map { |char| Integer(char) }
  end

  def get_guess_type
    guess = nil
    until guess == 'f' || guess == 'g' || guess == 'u'
      begin
        puts "type 'g' to guess; type 'f' to flag; type 'u' to unflag"
        p "> "
        guess = gets.chomp.downcase
      rescue
        puts "invalid guess type entered."
        puts ""

        guess = nil
      end
    end
    guess
  end

  def get_position
    pos = nil
    until pos && valid_pos(pos)
      begin
        puts "position? ex: '0,0'"
        print "> "
        pos = parse_pos(gets.chomp)
      rescue
        puts "invalid position entered."
        puts ""

        pos = nil
      end
    end

    pos
  end

  def play_turn
    board.render
    guess_type = get_guess_type
    position = get_position
    board.receive_guess(guess_type, position)
  end

end

require 'tile'

class Board

  attr_reader :height, :width

  def initialize(height, width, bomb_count)
    @grid = Array.new(height) { Array.new(width) }
    tile_count = height * width
    @height = height
    @width = width
    @tiles = []
    bomb_count.times { tiles << Tile.new(true) }
    (tile_count - bomb_count).times { tiles << Tile.new(false) }
    tiles.shuffle!
  end

  def populate_minefield
    @grid.each do |row|
      row.each_index do |idx|
        row[idx] = @tiles.pop
      end
    end
  end

  def render

  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    @grid[x][y] = tile
  end

  def get_tile_surroundings(pos)
    positions_to_check = []
    row, col = pos
    ((row-1)..(row+1)).each do |i|
      ((col-1)..(col+1)).each do |j|
        if i.between?(0..@height) && j.between?(0..@width)
          positions_to_check << [i, j] unless [i, j] == pos
        end
      end
    end
    positions_to_check
  end

  def find_bombs_around_tiles
    @grid.each_index do |row_index|
      row_index.each do |col_index|
        surroundings = get_tile_surroundings([row_index, col_index])
        surrounding_bomb_count = 0
        surroundings.each do |surrounding_position|
          if self[surrounding_position].contains_bomb
            surrounding_bomb_count += 1
          end
        end
        self[row_index, col_index].bombs_around_me = surrounding_bomb_count
      end
    end
  end

  def check_surrounding_positions(positions_to_check)
    positions_to_check.each do |position|
      unless self[position].contains_bomb
        if self[position].bombs_around_me > 0
          self[position].be_guessed
        elsif
          check_surrounding_positions(position)
        end
      end
    end
  end

  def receive_guess(guess_type, pos)
    if guess_type == 'f'
      self[pos].be_flagged
    elsif guess_type == 'u'
      self[pos].unflag
    elsif self[pos].contains_bomb
      return "lose"
    else
      self[pos].be_guessed
    end
  end

  def receive_flag(pos)
    self[pos].be_flagged
  end

end

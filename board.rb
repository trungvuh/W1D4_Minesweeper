require_relative 'tile'
require 'byebug'

class Board

  attr_reader :height, :width, :grid

  def initialize(height, width, bomb_count)
    @grid = Array.new(height) { Array.new(width) }
    tile_count = height * width
    @height = height
    @width = width
    @tiles = []
    bomb_count.times { @tiles << Tile.new(true) }
    (tile_count - bomb_count).times { @tiles << Tile.new(false) }
    @tiles.shuffle!
  end

  def populate_minefield
    @grid.each do |row|
      row.each_index do |idx|
        row[idx] = @tiles.pop
      end
    end
  end

  def render
    str = ""
    @width.each { |col_dex| str << " #{col_dex}" }
    str << "\n"
    @height.each do |row_dex|
      str << "#{row_dex} "
      @grid[row_dex].each { |tile| str << tile.to_s + " " }
      str << "\n"
    end
    p str
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    @grid[x][y] = tile
  end

  def find_bombs_around_tiles
    @grid.each_index do |row_index|
      @grid[row_index].each_index do |col_index|
        surroundings = get_tile_surroundings([row_index, col_index])
        surrounding_bomb_count = 0
        surroundings.each do |surrounding_position|
          if self[surrounding_position].contains_bomb == true
            surrounding_bomb_count += 1
          end
        end
        self[[row_index, col_index]].bombs_around_me = surrounding_bomb_count
      end
    end
  end

  def get_tile_surroundings(pos)
    positions_to_check = []
    row, col = pos
    ((row-1)..(row+1)).each do |i|
      ((col-1)..(col+1)).each do |j|
        if i.between?(0, @height) && j.between?(0, @width)
          positions_to_check << [i, j] if pos != [i, j]
        end
      end
    end
    byebug
    positions_to_check
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
      unless self[pos].contains_bomb
        check_surrounding_positions(get_tile_surroundings(pos))
      end
    end
  end

  def receive_flag(pos)
    self[pos].be_flagged
  end

end

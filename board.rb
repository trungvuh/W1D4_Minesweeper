require 'tile'

class Board

  def initialize(height, width, bomb_count)
    @grid = Array.new(height) { Array.new(width) }
    tile_count = height * width
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

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    @grid[x][y] = tile
  end

  

end

# Plate class
class Plate
  attr_reader :grid, :calc_plates

  PLATE_SIZES = {
    96 => { rows: 8, columns: 12 },
    384 => { rows: 16, columns: 24 }
  }.freeze

  def initialize(plate_size)
    rows, columns = PLATE_SIZES[plate_size].values
    @grid = Array.new(rows) { Array.new(columns) }
  end

  def generate_empty_layout
    calc_plates.times.each_with_object([]) do |_idx, out|
      out << grid
    end
  end

  def new_calc_plates(samples, reagents, num_of_replicates)
    @calc_plates = 0
    samples.each_with_index do |sample, index|
      @calc_plates += sample.size * reagents[index].size * num_of_replicates[index]
    end
    @calc_plates
  end
end

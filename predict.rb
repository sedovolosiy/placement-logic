require 'awesome_print'

# rubocop:disable Style/Documentation
class Predict
  PLATE_SIZES = {
    96 => { rows: 8, columns: 12 },
    384 => { rows: 16, columns: 24 }
  }.freeze

  def initialize(plate_size = 96, samples = [], reagents = [], num_of_replicates = [])
    @plate_size = plate_size
    @samples = samples
    @reagents = reagents
    @num_of_replicates = num_of_replicates
    @count_of_cells = count_of_cells
    @count_of_plates = calc_of_plates
    @layout = generate_empty_layout
  end

  def result_layout
    validate_num_replicates!

    pre_result = grouped_by_reagent(expanded_combination_result_flatten)
    visualize(alternative_layout(pre_result.values.flatten(1)))
  end

  private

  def alternative_layout(flatten_list = [])
    @layout.each do |plate|
      plate.map do |rows|
        rows.map! { |_item| flatten_list.shift }
      end
    end
    @layout
  end

  def expanded_combination_result_flatten
    @samples.map.with_index do |sample_list, index|
      sample_list.sort.map do |elem|
        @reagents[index].map do |reagent|
          @num_of_replicates[index].times.each_with_object([]) do |_idx, out|
            out << [elem, reagent]
          end
        end
      end
    end.flatten(3).sort
  end

  def count_of_cells
    count = 0
    @samples.each_with_index do |sample, index|
      count += sample.size * @reagents[index].size * @num_of_replicates[index]
    end
    count
  end

  def calc_of_plates
    (@count_of_cells / @plate_size) + ((@count_of_cells % @plate_size).zero? ? 0 : 1)
  end

  def generate_empty_layout
    @count_of_plates.times.each_with_object([]) do |_idx, out|
      out << Array.new(PLATE_SIZES[@plate_size][:rows]) { Array.new(PLATE_SIZES[@plate_size][:columns], '-') }
    end
  end

  def validate_num_replicates!
    return unless @samples.size != @num_of_replicates.size

    raise StandardError, "Invalid data for generating layout #{@samples.size} != #{@num_of_replicates.size}"
  end

  def grouped_by_reagent(data)
    data.group_by { |item| item[1].itself }
  end

  def visualize(array)
    ap array, multiline: false
  end
end

prediction = Predict.new(96,
                         [%w[Sample-1 Sample-2 Sample-3], %w[Sample-1 Sample-2]],
                         [['<Pink>', '<Yellow>', '<Green>'], ['<Green>']],
                         [7, 21])
puts prediction.result_layout

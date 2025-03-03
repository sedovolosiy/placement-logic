# Class for create layout of combinations
class Placement
  attr_reader :result

  PLATE_SIZES = {
    96 => { rows: 8, columns: 12 },
    384 => { rows: 16, columns: 24 }
  }.freeze

  def initialize(plate_size, samples, reagents, num_of_replicates)
    @plate_size = plate_size
    @samples = samples
    @reagents = reagents
    @num_of_replicates = num_of_replicates
    @count_of_cells = calc_cells
    @count_of_plates = calc_plates
    @layout = generate_empty_layout
  end

  #save result to file render.html in root
  def show_plates
    pre_result = grouped_by_reagent(expanded_combination_result_flatten)
    @result = fill_layout(pre_result.values.flatten(1))

    table = to_html_table(result)

    # write table to file
    File.open('./render.html', 'w') do |f|
      f.write table
    end
  end

  private

  # create result as html table
  def to_html_table(plates)
    plates.map.with_index do |plate, plate_num|
      '<table>' << "Plate #{plate_num + 1}" << '<tr>' <<
        plate.map do |sample_groups|
          '<td ' << sample_groups.map do |sample_group|
            if sample_group.nil?
              'style=background-color:gray> nil'
            else
              "style=background-color:#{sample_group[1].downcase}> #{sample_group}"
            end
          end.join('</td><td ') << '</td>'
        end.join('</tr><tr>') << '</tr></table>'
    end.join
  end

  # calculate total count of cells for define count of plate
  def calc_cells
    count = 0
    @samples.each_with_index do |sample, index|
      count += sample.size * @reagents[index].size * @num_of_replicates[index]
    end
    count
  end

  # total count of plates
  def calc_plates
    (@count_of_cells / @plate_size) + ((@count_of_cells % @plate_size).zero? ? 0 : 1)
  end

  # prepared flatted array for future group by reagent
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

  # filling layout
  def fill_layout(flatten_list = [])
    @layout.each do |plate|
      plate.map do |rows|
        rows.map! { flatten_list.shift }
        break if flatten_list.empty?
      end
    end
    @layout
  end

  # generating fixed size array for future data filling
  def generate_empty_layout
    @count_of_plates.times.each_with_object([]) do |_idx, out|
      out << Array.new(PLATE_SIZES[@plate_size][:rows]) { Array.new(PLATE_SIZES[@plate_size][:columns]) }
    end
  end

  # group by reagents for next loop as groupped data
  def grouped_by_reagent(data)
    data.group_by { |item| item[1].itself }
  end

  # simple validation
  def validate_num_replicates!
    return unless @samples.size != @num_of_replicates.size

    raise ArgumentError, 'Invalid parameters'
  end
end

result = Placement.new(96,
                       [%w[Sample-1 Sample-2 Sample-3], %w[Sample-1 Sample-2 Sample-4], %w[Sample-4]],
                       [%w[Pink Yellow Green], %w[Green Blue], ['Orange']],
                       [15, 21, 7])
#save preview to html file
result.show_plates

#show result as array
p result.result

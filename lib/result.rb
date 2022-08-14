# frozen_string_literal: true

# get filled 2d array with samples and reagents
class Result
  attr_reader :grid, :results, :all_combination

  def initialize(grid, all_combination)
    @grid = grid
    @all_combination = all_combination
  end

  def get
    pre_result = grouped_by_reagent(all_combination)
    fill_layout(pre_result.values.flatten(1))
  end

  private

  # filling layout
  def fill_layout(flatten_list)
    @results = grid.each do |plate|
      plate.map do |rows|
        rows.map! { flatten_list.shift }
        break if flatten_list.empty?
      end
    end
  end

  # group by reagents for next loop as groupped data
  def grouped_by_reagent(data)
    data.group_by { |item| item[1].itself }
  end
end

# frozen_string_literal: true

require_relative './lib/plate'
require_relative './lib/result'
require_relative './lib/save_data_to_html'

# input data
plate_size = 96
samples = [%w[Sample-1 Sample-2 Sample-3], %w[Sample-1 Sample-2 Sample-4], %w[Sample-4]]
reagents = [%w[Pink Yellow Green], %w[Green Blue], %w[Orange]]
num_of_replicates = [15, 21, 7]

# start
# create plate
plate = Plate.new(plate_size, samples, reagents, num_of_replicates)

# create raw result date
raw_result = Result.new(plate.grid, plate.all_combination)

# save array data to html table
to_file = SaveDateToHtml.new(raw_result.get)
to_file.save

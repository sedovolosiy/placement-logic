# frozen_string_literal: false

# save raw array 2d array to html table
class SaveDateToHtml
  attr_reader :results

  def initialize(results)
    @results = results
  end

  def save
    # write table to file
    File.open('./render.html', 'w') do |f|
      f.write to_html_table
    end
  end

  private

  def to_html_table
    results.map.with_index do |plate, plate_num|
      '<table>' << "Plate #{plate_num + 1}" << '<tr>' <<
        table_body(plate)
    end.join
  end

  def table_body(plate)
    plate.map do |sample_groups|
      '<td ' << sample_groups.map do |sample_group|
        if sample_group.nil?
          'style=background-color:gray> nil'
        else
          "style=background-color:#{sample_group[1].downcase}> #{sample_group}"
        end
      end.join('</td><td ') << '</td>'
    end.join('</tr><tr>') << '</tr></table>'
  end
end

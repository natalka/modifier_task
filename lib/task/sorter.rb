#sort by given column in DESC order and save it to CSV
module Task
  class Sorter
    class << self

      def sort(file, sorting_column)
        output = "#{file}.sorted"
        content_as_table = parse(file)
        headers = content_as_table.headers
        index_of_key = headers.index(sorting_column)
        content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
        write(content, headers, output)
        return output
      end

      private

      def parse(file)
        CSV.read(file, DEFAULT_CSV_OPTIONS)
      end

      def write(content, headers, output)
        CSV.open(output, "wb", WRITE_CSV_OPTIONS) do |csv|
          csv << headers
          content.each do |row|
            csv << row
          end
        end
      end

    end
  end
end

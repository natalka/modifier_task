module Task
  class Modifier
    KEYWORD_UNIQUE_ID = 'Keyword Unique ID'
    LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword',
      'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN',
      'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
    LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
    INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks',
      'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
    FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
    NO_OF_COMMISSIONS = 'number of commissions'
    COMMISSIONS_VALS = ['Commission Value', 'ACCOUNT - Commission Value',
      'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value',
      'ADGROUP - Commission Value', 'KEYWORD - Commission Value']
    SORT_BY_CLICKS = 'Clicks'

    LINES_PER_FILE = 120000

    def initialize(saleamount_factor, cancellation_factor)
      @saleamount_factor = saleamount_factor
      @cancellation_factor = cancellation_factor
    end

    def modify(output, input)
      input = Sorter.sort(input, SORT_BY_CLICKS)

      input_enumerator = lazy_read(input)
      combiner = Combiner.new do |value|
        value[KEYWORD_UNIQUE_ID]
      end.combine(input_enumerator)

      merger = Enumerator.new do |yielder|
        while true
          begin
            list_of_rows = combiner.next
            merged = combine_hashes(list_of_rows)
            yielder.yield(combine_values(merged))
          rescue StopIteration
            break
          end
        end
      end
      write_to_csvs(merger, output)
    end

    private

    def write_to_csvs(merger, output)
      done = false
      file_index = 0
      file_name = output.gsub('.txt', '')
      while is_finished?(merger) do
        CSV.open(file_name + "_#{file_index}.txt", "wb", WRITE_CSV_OPTIONS) do |csv|
          csv << merger.peek.keys if is_finished?(merger)
          line_count = 1
          while line_count < LINES_PER_FILE && is_finished?(merger)
            merged = merger.next
            csv << merged
            line_count +=1
          end
          file_index += 1
        end
      end
    end

    def is_finished?(enum)
      begin
        enum.peek
      rescue StopIteration
        nil
      end
    end

    def combine(merged)
      result = []
      merged.each do |_, hash|
        result << combine_values(hash)
      end
      result
    end

    def combine_values(hash)
      LAST_VALUE_WINS.each do |key|
        hash[key] = hash[key].last
      end
      LAST_REAL_VALUE_WINS.each do |key|
        hash[key] = hash[key].select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last
      end
      INT_VALUES.each do |key|
        hash[key] = hash[key][0].to_s
      end
      FLOAT_VALUES.each do |key|
        hash[key] = hash[key][0].from_german_to_f.to_german_s
      end
      hash[NO_OF_COMMISSIONS] =
        (@cancellation_factor * hash[NO_OF_COMMISSIONS][0].from_german_to_f).to_german_s
      COMMISSIONS_VALS.each do |key|
        hash[key] =
          (@cancellation_factor * @saleamount_factor * hash[key][0].from_german_to_f).to_german_s
      end
      hash
    end

    def combine_hashes(list_of_rows)
      keys = []
      list_of_rows.each do |row|
        next if row.nil?
        row.headers.each do |key|
          keys << key
        end
      end
      result = {}
      keys.each do |key|
        result[key] = []
        list_of_rows.each do |row|
          result[key] << (row.nil? ? nil : row[key])
        end
      end
      result
    end

    def lazy_read(file)
      Enumerator.new do |yielder|
        CSV.foreach(file, DEFAULT_CSV_OPTIONS) do |row|
          yielder.yield(row)
        end
      end
    end

  end
end

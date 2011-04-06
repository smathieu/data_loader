# DataLoader::Loader
#
# Loads CSV files into MySQL
#
# Config:
#
#   folder
#     base folder for calls to load()
#   table_prefix
#     prefix for derived table names
#     very important because an existing table will be overwritten!!!
#   inspect_rows
#     how many rows to scan the CSV file to determine the data types
#   connection
#     a connection name from database.yml to run it under (e.g. :production)
#   default_ext
#     extension to append if no file extension is specified
#   separator
#     a comma (,)
#   log
#     true/false

module DataLoader

  class Loader
    attr_accessor :folder, :table_prefix, :default_ext, :inspect_rows, :connection, :separator, :log

    def initialize(folder = '', separator = ',', table_prefix = 'load', connection = :root)
      @folder, @separator = folder, separator
      @table_prefix, @connection = table_prefix, connection
      @default_ext = 'csv'
      @inspect_rows = 10
      @log = true
      yield(self) if block_given?
      @logfile = File.expand_path(File.join(@folder, 'data_loader.textile'))
      puts @logfile
    end

    def load(filename, table = nil)
      filename = [filename, default_ext].join('.') if File.extname(filename).empty?
      full_file = File.expand_path(File.join(@folder, filename))
      table = Migrator.derive_table_name(filename) if table.nil?
      table = [@table_prefix, table].join('_') unless @table_prefix.blank?
      columns = Inspector.inspect_file(full_file, @separator, @inspect_rows)
      log_columns(table, columns)
      Migrator.migrate(full_file, columns, table, @separator, @connection)
      table
    end
    
    def log(text)
      return unless @log
      
      File.open(@logfile, 'a') do |file|
        file << text
      end
    end
    
    def clear_log
      FileUtils.remove(@logfile) if File.exist?(@logfile)
    end

  private

    def log_columns(table, columns)
      return unless @log
      
      File.open(@logfile, 'a') do |file|
        file << "\ntable{width:80%}.\n|_\\2. #{table} |\n"   # table header (textile)
        columns.each_with_index do |column, index|
          if index == 0
            file << "|{width:50%}. #{column[:name]} |{width:50%}. :#{column[:type]} |\n"  # 50% on first row
          else
            file << "| #{column[:name]} | :#{column[:type]} |\n"  # table row (textile)
          end
        end
      end
    end
    
  end
end




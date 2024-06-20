require 'ougai'
require 'rack/ougai'

# Ensure the log directory exists
log_dir = File.expand_path('../../../log', __FILE__)
Dir.mkdir(log_dir) unless Dir.exist?(log_dir)

# Configure Ougai logger
logger = Ougai::Logger.new(File.join(log_dir, 'app.log'))
logger.formatter = Ougai::Formatters::Readable.new

use Rack::Ougai::Logger, logger: logger

# Assign logger to a global variable for other uses
$logger = logger

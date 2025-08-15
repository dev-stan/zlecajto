# frozen_string_literal: true

# Configure Active Storage variant processor.
# Using :vips is typically faster and uses less memory than ImageMagick, and reduces
# the chance of 500 errors when ImageMagick isn't installed. Install libvips on the host:
#   sudo apt-get update && sudo apt-get install -y libvips
# If you prefer ImageMagick, remove this and ensure ImageMagick is installed instead.
Rails.application.config.active_storage.variant_processor = :mini_magick

# If you later install libvips (sudo apt-get install -y libvips), you can switch
# back to :vips for faster processing.

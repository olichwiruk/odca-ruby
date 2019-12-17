require 'odca/version'
require 'odca/parser'
require 'odca/schema_base'
require 'odca/headful_overlay'
require 'odca/parentful_overlay'
require 'odca/overlays/format_overlay'
require 'odca/overlays/label_overlay'
require 'odca/overlays/encode_overlay'
require 'odca/overlays/entry_overlay'
require 'odca/overlays/information_overlay'
require 'odca/overlays/conditional_overlay'
require 'odca/overlays/source_overlay'
require 'odca/overlays/review_overlay'
require 'odca/overlays/masking_overlay'
require 'odca/overlays/mapping_overlay'

module Odca
  ROOT_PATH = File.expand_path('..', File.dirname(__FILE__))
end

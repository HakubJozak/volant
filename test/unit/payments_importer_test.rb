require 'test_helper'

class PaymentsImporterTest < ActiveSupport::TestCase

  def test_simple_import
    importer = PaymentsImporter.new('test/fixtures/xml-payments/paytest.xml')
    importer.import_all(nil)
  end

end

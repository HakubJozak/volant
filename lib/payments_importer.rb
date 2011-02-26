class PaymentsImporter

  include XmlHelper

  def initialize(file)
    @doc = REXML::Document.new(File.new(file))
  end

  def import_all(listener)
    payments = @doc.elements.each('/OFX/BANKTRANLIST/MOV') do |node|
      next unless to_text(node, 'TRNTYPE') == 'CREDIT'
      next unless to_text(node, 'MEMO/CURRENCY') == 'CZK'

      # ... to_decimal(node, 'TRNAMT')
      posted = to_date(node, 'DTPOSTED','%Y%d%m')
      available = to_date(node, 'DTAVAIL','%Y%d%m')

      to_text(node, 'TRNCOSYM')
      to_text(node, 'TRNSPSYM')
      to_text(node, 'TRNVASYM')
      to_text(node, 'TRNCOSYM')
      to_text(node, 'NAME')

      p = Payment.new
      p.account = to_text(node, 'BANKACCTO/ACCTID')
      p.bank_code = to_text(node, 'BANKACCTO/BANKID')
    end

    payments.compact!
  end

  def to_date
  end

end

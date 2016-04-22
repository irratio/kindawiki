require 'kindamarkup/kindamarkup'

class KindamarkupHtml
  @parser = KindamarkupParser.new

  def self.to_html(data)
    tree = @parser.parse(data)

    raise Exception, "Parse error at offset: #{@parser.index}" if tree.nil?

    tree.to_html
  end
end

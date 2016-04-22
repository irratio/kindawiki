class Treetop::Runtime::SyntaxNode
  def to_html
    if elements
      elements.map { |e| e.to_html }.join
    else
      text_value
    end
  end
end

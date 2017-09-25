module WickedPdfHelper
  def wicked_pdf_asset(file)
    "file://#{File.join(Rails.root, 'public', file)}"
  end

  def wicked_pdf_inject(file)
    file = File.open("#{File.join(Rails.root, 'public', file)}", 'rb')
    file.read.html_safe
  end
end

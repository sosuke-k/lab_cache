module ApplicationHelper

  #TODO move to decorator
  def extract_url(url)
    url = URI(url)
    extracted_url = url.scheme + '://' + url.host + url.path
  end
end

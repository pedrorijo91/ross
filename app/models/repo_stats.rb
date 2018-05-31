class RepoStats

  attr_reader :name, :url, :stars, :forks, :language

  def initialize(id, name, url, stars, forks, language)
    @id = id
    @name = name
    @url = url
    @stars = stars
    @forks = forks
    @language = language
  end

end
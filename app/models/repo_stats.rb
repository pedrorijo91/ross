class RepoStats

  attr_reader :name, :url, :stars, :forks, :language, :score

  def initialize(id, name, url, stars, forks, language, score)
    @id = id
    @name = name
    @url = url
    @stars = stars
    @forks = forks
    @language = language
    @score = score
  end

end
class RepoStats

  attr_reader :name, :url, :stars, :forks

  def initialize(id, name, url, stars, forks)
    @id = id
    @name = name
    @url = url
    @stars = stars
    @forks = forks
  end

  def score
    @score ||= compute_score
  end

  private def compute_score
    42 # TODO
  end


end
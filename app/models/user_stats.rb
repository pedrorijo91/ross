class UserStats

  attr_reader :username, :url, :image, :repos, :languages

  def initialize(id, username, url, image, repo_stats, nbr_stared, nbr_forks)
    @id = id
    @username = username
    @url = url
    @image = image
    @repos = repo_stats
    @nbr_stared = nbr_stared
    @nbr_forks = nbr_forks
  end

  def score
    @score ||= compute_score
  end

  def languages
   @languages ||= compute_languages
  end

  private def compute_score
    @repos.map { |repo| repo.stars * 10 + repo.forks + 10}.sum + @nbr_stared * 3 + @nbr_forks * 5
  end

  private def compute_languages
    langs = @repos.map {|repo| repo.language}
    groupped = langs.group_by {|lang| lang}

    count = {}
    groupped.each {|key, arr| count[key] = arr.size}
    count
  end

end
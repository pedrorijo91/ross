class UserStats

  attr_reader :username, :profile_url, :avatar_url, :repos, :languages, :orgs_user_belong

=begin
  username
  image

  top languages

  points

  for each personal + org (repo stats):
    - owner/project
    - nbr stars
    - nbr forks

=end


  def initialize(id, username, profile_url, avatar_url, repo_stats, nbr_stared, nbr_forks, orgs_user_belong)
    @id = id
    @username = username
    @profile_url = profile_url
    @avatar_url = avatar_url
    @repos = repo_stats
    @nbr_stared = nbr_stared
    @nbr_forks = nbr_forks
    @orgs_user_belong = orgs_user_belong
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
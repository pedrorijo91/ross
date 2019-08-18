class UserStats

  attr_reader :username, :profile_url, :avatar_url, :repos, :languages, :orgs_user_belong, :score

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


  def initialize(id, username, profile_url, avatar_url, repo_stats, nbr_stared, nbr_forks, orgs_user_belong, score)
    @id = id
    @username = username
    @profile_url = profile_url
    @avatar_url = avatar_url
    @repos = repo_stats
    @nbr_stared = nbr_stared
    @nbr_forks = nbr_forks
    @orgs_user_belong = orgs_user_belong
    @score = score
  end

  def languages
   @languages ||= compute_languages
  end

  private def compute_languages
    langs = @repos.map(&:language).compact
    groupped = langs.group_by {|lang| lang}

  #  puts "Computing user lang stats for #{username} -> #{ @repos.map {|repo| [repo.name, repo.language]} }"

    count = {}
    groupped.each {|key, arr| count[key] = arr.size}
    count
  end

end
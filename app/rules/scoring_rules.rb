class ScoringRules

  def score_repo(stars, forks)
    stars * 5 + forks * 7
  end

  def score_user(repo_stats, nbr_stared, nbr_forks)
    repo_stats.map { |repo| score_repo(repo.stars, repo.forks)}.sum + nbr_stared * 3 + nbr_forks * 5
  end

end

# TODO https://github.com/pedrorijo91/ross-issues/issues/2
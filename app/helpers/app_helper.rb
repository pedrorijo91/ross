module AppHelper
  def level_label(score)
    puts "score: #{score} -> #{score < 100}"
    case score
    # TODO add labels
    when 0
      "zero?"
    when 1..100
      "loser"
    when 100..1000
      "hmmmm"
    when 1000..10000
      "wow"
    else
      return 'not bad'
    end
  end
end
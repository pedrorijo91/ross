module AppHelper
  def level_label(score)
    puts "score: #{score} -> #{score < 100}"
    case score
    # TODO add labels
    when 0
      "Go for it! You are more than capable!"
    when 1..100
      "The first step is the hardest one 🎉"
    when 100..1000
      "It doesn't matter how slow you go, as long as you don't stop"
    when 1000..10000
      "On the path to become a rockstar, are you?"
    else
      return "The (open-source) world is yours!"
    end
  end
end
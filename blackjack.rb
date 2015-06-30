class Blackjack
  def initialize
    # Constants
    @DECK = { "hearts" => [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"],
             "spades" => [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"],
             "clubs" => [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"],
             "diamonds" => [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"]
           }

    @SUITS = ["hearts", "spades", "clubs", "diamonds"]

    @VALUE_OF_JQK = 10
    @VALUE_OF_ACE_1 = 1
    @VALUE_OF_ACE_11 = 11
    # End Constants
    @player_score = 0
    @house_score = 0
  end

  def get_random_card
    random_suit = Random.rand(@SUITS.length)
    suit = @SUITS[random_suit]
    random_position_of_array = Random.rand(@DECK[suit].length)
    card = @DECK[suit][random_position_of_array]
    @DECK[suit] = @DECK[suit] - [random_position_of_array]
    return card
  end

  def play?
    puts "Would you like to play Blackjack?"
    response = gets.chomp.downcase
    if response.start_with?('y')
      play_blackjack(@player_score, @house_score)
    else
      puts "Maybe next time."
      exit()
    end
  end

  def start_game
    puts "Hello and Welcome to the Gold Saucer Casino!"
    puts "Due to renovations, we only have Blackjack available."
    puts "We apologize for this inconvenience."
    play?
  end

  def get_card_value(card, current_score)
    if (card == "Q" || card == "J" || card == "K")
      value = @VALUE_OF_JQK
      return value
    elsif (card == "A")
      value = choose_ace_value(current_score)
      return value
    else
      return card
    end
  end

  def choose_ace_value(current_score)
    if (current_score <= 10)
      return @VALUE_OF_ACE_11
    else
      return @VALUE_OF_ACE_1
    end
  end

  def play_blackjack(player_score, house_score)
    players = ["player", "house"]
    turn = players[0]
    puts "Okay, here we go...\n\n"
    while (turn == "player")
      current_card = get_random_card()
      player_score += get_card_value(current_card, player_score)
      puts "You drew a #{current_card}."
      puts "Your current score is #{player_score}.\n\n"
      check_valid_score(player_score, turn)
      puts "Would you like to draw again?\n"
      response = gets.chomp.downcase
      if (response.start_with?('y'))
        play_blackjack(player_score, house_score)
      else
        turn = players[1]
      end
    end
    while (turn == "house")
      house_card = get_random_card()
      puts "The house drew a #{house_card}."
      house_score += get_card_value(house_card, house_score)
      puts "House current score: #{house_score}.\n\n"
      check_valid_score(house_score, turn)
      turn = house_ai(player_score, house_score)
    end
    if (turn != "player" or turn != "house")
      get_winner(player_score, house_score)
    end
  end

  def house_ai(player_score, house_score)
    if (player_score > house_score)
      return "house"
    else
      return "finish"
    end
  end

  def reset_score
    @player_score = 0
    @house_score = 0
  end

  def check_valid_score(current_score, current_player)
    if (current_score > 21)
      invalid_score = true
    end
    if (invalid_score && current_player == "player")
      puts "The house wins."
      reset_score()
      play?
    elsif (invalid_score && current_player == "house")
      puts "Congratulations! You've won."
      reset_score()
      play?
    else
      reset_score()
      return
    end
  end

  def get_winner(player_score, house_score)
    if (player_score > house_score)
      reset_score()
      puts "The player wins!"
    elsif (house_score > player_score)
      reset_score()
      puts "The house always wins."
    else
      puts "That's a tie."
      reset_score()
    end
  end
end

game = Blackjack.new
game.start_game

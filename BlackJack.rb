require './player'
require './deck'


class Game
  attr_reader :deck, :dealer, :players

  def initialize
    @deck = Deck.new   
    @dealer = Player.new "Dealer"
    @players = []
  end

  def create_deck
    @deck.make_deck
#    res = []

#    hearts = make_suite("\u2665")
#    diamonds = make_suite("\u2666")
#    spades = make_suite("\u2660")
#    clubs = make_suite("\u2663")
    # just concat the make_suite method with each unicode character
#    res.concat(hearts)
#    res.concat(diamonds)
#    res.concat(spades)
#    res.concat(clubs)
#    res.shuffle
  end

  def make_suite(suite)
    non_face = [*2..10]

    non_face.map! {|x| x.to_s }
    face = ["A","J","Q","K"]
    face.concat(non_face)
    face.map! do |x|
      x+= suite
      # below try making [x.to_s] to make an array with x as a string at index 1
      if x.length == 2
        x = [x, ["|", "\u203E" *8, "|"], ["|#{x}"," "*6, "|"],["|", " "*8, "|"],["|", " "*6, "#{x}|"], ["|", "_"*8, "|"]]
      elsif x.length == 3
        x = [x, ["|", "\u203E" *8, "|"], ["|#{x}"," "*5, "|"],["|", " "*8, "|"],["|", " "*5, "#{x}|"], ["|", "_"*8, "|"]]
      end
    end
    face
  end

  def add_player(name)
    name = Player.new(name)
    @players.push(name)
  end

  def deal_card(player)
    player.hand.hit(@deck.stack.pop)
  end

  def player_menu
    # will prompt user to input a name which will be used to instantiate Player class, specifics of this can probably
    # be moved to Player class itself as an instance method
    clear_scrn
    print "Add a player: "
    inp = gets.chomp
    add_player(inp)
    print "\nAdd another? Y/n: "
    ans = gets.chomp.downcase
    if ans == "y"
      player_menu
    end
  end

  def deal_in
    2.times {deal_card(@dealer)}
    2.times do
      @players.each {|x| deal_card(x)}
    end
    puts "Dealer: "
    @dealer.print_card(@dealer.hand[0])
    sleep(2)
  end

  def player_bet(player)
    clear_scrn
    puts "#{player.name} place bet, you have $#{player.purse}"
    amnt = gets.chomp
    if amnt =~ /\A\d*\.*\d*\Z/
      if amnt.to_f <= player.purse
        player.bet = amnt.to_f.round(2)
      else
        puts "you don't got the dough"
        sleep(1.5)
        player_bet(player)
      end
    else
      puts "Need a number only"
      sleep(1.5)
      player_bet(player)
    end
  end

  def dealer_hand
    clear_scrn
    @dealer.check_hand
    @dealer.print_hand
    if @dealer.sum < 17
      sleep(1.15)
      deal_card(@dealer)
      dealer_hand
    end
    clear_scrn
    @dealer.print_hand
  end

  def player_turn(player)
    clear_scrn
    check_deck
    player.check_hand
    if !player.bust
      player.print_hand
      if player.hand.length == 2
        print "\nYour action [S]tand, [H]it, [D]ouble down?: "
      else
        print "\nYour action [S]tand, [H]it: "
      end
      resp = gets.chomp.downcase
      if resp == "s"
        nil
      elsif resp == "h"
        deal_card(player)
        player.check_hand
        player.print_hand
        player_turn(player)
      elsif resp == "d" && player.hand.length == 2
        player.bet = player.bet*2
        deal_card(player)
        player.check_hand
        clear_scrn
        player.print_hand
        sleep(1.5)
      else
        puts "Not recognized try again"
        sleep(1.5)
        player_turn(player)
      end
    else
      player.print_hand
      puts "Busted!"
      sleep(1)
    end
  end

  def payout(group)
    group.each do |x|
      if x.black_jack
        x.purse += (x.bet * 2.5)
      else
        x.purse += (x.bet * 2)
      end
      x.purse = x.purse.to_f.round(2)
      x.bet = 0
    end
  end

  def end_round
    if !@dealer.bust && !@dealer.black_jack
      winners = @players.find_all {|player|  (!player.bust && player.sum > @dealer.sum && player.purse >0) || player.black_jack }
      payout(winners)

      even = @players.find_all {|player| player.sum == @dealer.sum && !player.black_jack}
      even.each do |x|
        x.bet = 0
        x.purse = x.purse.to_f.round(2)
      end
      losers = @players.find_all {|player| player.bust || player.sum < @dealer.sum}
      losers.each do |x|
        x.purse -= x.bet
        x.purse = x.purse.to_f.round(2)
        x.bet = 0
      end
    elsif @dealer.black_jack
      even = @players.find_all {|player| player.black_jack}
      even.each do |x|
        x.bet = 0
        x.purse = x.purse.to_f.round(2)
      end
      winners = []
      losers = @players.find_all {|player| player.bust || !player.black_jack}
      losers.each do |x|
        x.purse -= x.bet
        x.purse = x.purse.to_f.round(2)
      end
    else
      winners = @players.find_all {|player| !player.bust && player.purse > 0}
      payout(winners)
      even = []
      losers = @players.find_all {|player| player.bust}
      losers.each do |x|
        x.purse -= x.bet
        x.purse = x.purse.to_f.round(2)
      end
    end

    if winners.length == 0  && even.length == 0
      puts "House Wins"
    else
      print "Winners!: "
      if winners
        winners.each {|x| print x.name + ", " }
      end
      print "\nPush: "
      if even
        even.each {|x| print x.name + ", "}
      end
    end
    @dealer.hand.clear
    @players.each do |x|
      x.hand.clear
    end
  end

  def play_again
    print "\nPlay another hand? Y/n: "
    resp = gets.chomp.downcase
    if resp == "n"
      true
    elsif resp == "y"
      false
    else
      puts "Not recognized please enter Y or N"
      sleep(1.5)
      play_again
    end
  end

  def any_money
    able = @players.find_all {|x| x.purse > 0}
    if able.length == 0
      clear_scrn
      puts "Game Over"
      sleep(1.25)
      clear_scrn
      puts "Game Over, game over man"
      sleep(2)
      @players.clear
      false
    else
      true
    end
  end

  def game_run
    player_menu
    while true
      if !any_money
        if play_again
          break
        else
          game_run
        end
      end
      round
      if play_again
        break
      end
    end
  end

  def check_deck
    if @deck.length <= ((@players.length + 1)*2)
      @deck.concat(create_deck)
    end
  end

  def clear_scrn
    system "clear"
  end

  def round
    clear_scrn
    check_deck
    @players.each do |player|
      if player.purse > 0
        player_bet(player)
      else
        next
      end
    end
    clear_scrn
    deal_in
    @players.each do|player|
      if player.purse > 0
        player_turn(player)
      end
    end
    # Add to bet? done
    dealer_hand
    end_round
  end
end

h=Game.new
h.game_run

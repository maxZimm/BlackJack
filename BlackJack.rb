require_relative 'blackjack_helper'

class BlackJack 
  attr_reader :deck, :dealer, :players

  def initialize
    @deck = Deck.new   
    @dealer = Player.new("Dealer")
    @players = []
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
  
  private

  def create_deck
    @deck.make_deck
  end

  def add_player(name)
    name = Player.new(name)
    @players.push(name)
  end

  def deal_card(player)
    player.hand.hit(@deck.stack.pop)
  end

  def player_menu
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
      @players.each {|player| deal_card(player)}
    end
    puts "Dealer: "
    puts @dealer.hand.cards[0].print_card
    sleep(2)
  end

  def collect_bet(player)
    clear_scrn
    puts "#{player.name} place bet, you have $#{player.purse}"
    amount = gets.chomp
    if amount =~ /\A\d*\.*\d*\Z/ && amount.to_f <= player.purse
      player.bet(amount.to_f.round(2))
    elsif amount !~ /\A\d*\.*\d*\Z/
      puts "Need a number only"
      sleep(1.5)
      collect_bet(player)
    else
      puts "you don't got the dough"
      sleep(1.5)
      collect_bet(player)
    end
  end

  def dealer_hand
    clear_scrn
    @dealer.print_hand
    if @dealer.hand.points < 17
      sleep(1.15)
      deal_card(@dealer)
      dealer_hand
    end
    clear_scrn
    @dealer.print_hand
  end

  def player_turn(player)
    clear_scrn
    #player.move      
    if !player.hand.bust
      player.print_hand
      if player.hand.cards.length == 2
        print "\nYour action [S]tand, [H]it, [D]ouble down?: "
      else
        print "\nYour action [S]tand, [H]it: "
      end
      resp = gets.chomp.downcase
      if resp == "s"
        nil
      elsif resp == "h"
        deal_card(player)
        player.print_hand
        player_turn(player)
      elsif resp == "d" && player.hand.cards.length == 2
        player.betted = player.betted * 2
        deal_card(player)
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
    group.each do |player|
      if player.hand.blackjack?
        player.purse += (player.betted * 2.5)
      else
        player.purse += (player.betted * 2)
      end
    end
  end

  def end_round
    payout(winners)
    resolve_losers(losers)
    round_results 
    clear_all_hands
  end

  def winners
    if @dealer.hand.bust
      @players.find_all {|player| !player.hand.bust }
    else 
      @players.find_all {|player| !player.hand.bust && (player.hand.points > @dealer.hand.points)}
    end
  end

  def resolve_losers(players)
    if players.any?
      players.each {|player| player.purse -= player.betted } 
    end 
  end

  def losers
    if @dealer.hand.bust
      @players.find_all {|player| player.hand.bust}
    else
      @players.find_all {|player| player.hand.points < @dealer.hand.points || player.hand.bust }
    end
  end

  def evens
    if !@dealer.hand.bust
      @players.find_all {|player| player.hand.points == @dealer.hand.points}
    else
      []
    end
  end
  
  def round_purse(player)
     player.purse = player.purse.to_f.round(2)
  end

  def clear_all_hands
    @dealer.hand.clear
    @players.each do |player|
      player.hand.clear
      player.reset_bet
    end
  end

  def round_results
    if winners.length == 0  && evens.length == 0
      puts "House Wins"
    else
      print "Winners!: "
      if winners.any?
        winners.each {|winner| print winner.name + " " }
      end
      print "\nPush: "
      if evens.any?
        evens.each {|even| print even.name + " "}
      end
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

  def able_players
    @players.find_all {|player| player.purse > 0}
  end

  def any_money
    if able_players.length == 0
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

  def check_deck
    if @deck.stack.length <= ((@players.length + 1)*2)
      @deck.make_deck
    end
  end

  def clear_scrn
    system "clear"
  end

  def round
    clear_scrn
    check_deck
    able_players.each {|player| collect_bet(player)}
    clear_scrn
    deal_in
    able_players.each {|player| player_turn(player)}
    dealer_hand
    end_round
  end
end

h = BlackJack.new
h.game_run

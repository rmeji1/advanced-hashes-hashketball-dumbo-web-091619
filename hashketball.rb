# Write your code here!
require 'yaml'

def game_hash
  YAML.load_file("./game__details.yaml")
  # p game_stats[:home][:players]
  # p game_stats[:away][:players]
end

def num_points_scored(name)
  hash = game_hash
  hash.each_pair do |key, team_stats|
    points = find_stat_in_team_stats_for_player(name, team_stats, :points)
    return points if points
  end
end

def shoe_size(name)
  hash = game_hash
  hash.each_pair do |key, team_stats|
    size = find_stat_in_team_stats_for_player(name, team_stats, :shoe)
    return size if size
  end
end

def find_stat_in_team_stats_for_player(name, team_stats, stat_name)
  team_stats[:players].each do |player| 
    if player.keys[0] == name 
      return player[name][stat_name]
    end
  end
  return nil
end

def team_colors(team)
  hash = game_hash
  hash.each_pair do |key, team_stats| 
    if team == team_stats[:team_name]
      return team_stats[:colors]
    end
  end 
end

def team_names
  hash = game_hash
  [ hash[:home][:team_name], hash[:away][:team_name] ]
end

def player_numbers(team_name)
  hash = game_hash
  hash.each_pair do |key, team_stats|
    if team_stats[:team_name] == team_name
      return team_stats[:players].map {|player| player.values[0][:number] }
    end
  end
end

def player_stats(name)
  hash = game_hash
  hash.each_pair do |key, team_stats|
    team_stats[:players].each do |player| 
      if player.keys[0] == name 
        return player[name]
      end
  end
  end
end

def get_players_for_team(team_name)
  hash = game_hash
  hash.each_pair do |key, team_stats|
    if team_stats[:team_name] == team_name
      return team_stats[:players].map {|player| player.keys[0] }
    end
  end
end

def find_player_with_max(players, stat)
  max = 0
  
  players.reduce("") do |memo, player|
    size = player_stats(player)[stat]
    if  size > max
      memo = player
      max = size
    end
    memo
  end 
  
end

def get_all_players
  teams = team_names
  get_players_for_team(teams[0]) + get_players_for_team(teams[1])
end

def big_shoe_rebounds
  player_with_biggest_shoe = find_player_with_max(get_all_players, :shoe)
  player_stats(player_with_biggest_shoe)[:rebounds]
end

def most_points_scored
  p find_player_with_max(get_all_players, :points)
end

def winning_team
  teams = team_names
  didHomeWin(teams[0], teams[1]) ? team_names[0] : team_names[1]
end

def didHomeWin(home_team, away_team)
  home_score = calculate_score_for_team(home_team)
  away_score = calculate_score_for_team(away_team)
  home_score > away_score ? true : false
end

def calculate_score_for_team(team)
  players = get_players_for_team(team) 
  players.reduce(0) do |memo, player|
    memo += num_points_scored(player)
  end
end

def player_with_longest_name
  get_all_players.max { |a, b| a.length <=> b.length }
end

def long_name_steals_a_ton?
  return !!(find_player_with_max(get_all_players, :steals) == player_with_longest_name)
    
end
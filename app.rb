require 'sinatra'
require 'enumerator'
require 'json'

get "/" do
  content_type :json
  absence = params['text'] || ''
  res = pair_while_absence absence
  res.to_json
end

post "/" do
  content_type :json
  absence = params['text'] || ''
  res = pair_while_absence absence
  res.to_json
end


def pair_while_absence absence=''
  all_members = %w(louis jichao ting praveen mel)

  condition = 'All good'
  condition = "Given *#{absence.capitalize}* is absent" if absence != ''
  condition = "Given #{absence.split(',').map {|x| "*#{x.capitalize}*"}.join(", ") } are absent" if absence.include? ','

  paring = []
  all_members.select {|name| not absence.split(',').include? name }.shuffle.each_slice(2) do |pair|
    paring.push(pair)
  end

  def display pair
    p1, p2 = pair
    return "*#{p1.capitalize}* will pair with *#{p2.capitalize}*.\n" unless p2.nil?
    "*#{p1.capitalize}* works alone.\n"
  end

  {
    :response_type => 'in_channel',
    :text => "#{condition}, #{Time.now.strftime('%b %d, %Y')}'s pairing plan:\n\n#{paring.map {|x| display x}.join("\n") }",
    :mrkdwn => true
  }
end
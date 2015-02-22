require 'json'
require 'net/http'

url = ARGV[0]
regex = Regexp.new('4chan.org/(\w+)/thread/(\d+)')

if url.nil?
  abort("usage:\n\t#{File.basename($0)}\sURL")
elsif regex.match(url).nil?
  abort("Invalid\sURL:\n\t\"#{url}\"")
end

board, thread = regex.match(url)[1..2]
json_url = 'http://a.4cdn.org/' + board + '/thread/' + thread + '.json'
res = Net::HTTP.get(URI(json_url))

if res.empty?
  abort('Network error!')
end

json = JSON.parse(res)
imgs = json['posts'].select{ |p| p['filename'] }
img_urls = imgs.map{ |i| ['http://i.4cdn.org/', board, '/', i['tim'], i['ext']].join }

puts img_urls.join("\n")


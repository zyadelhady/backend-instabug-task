Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['ELASTIC_URL'])
$elastic = Elasticsearch::Model.client

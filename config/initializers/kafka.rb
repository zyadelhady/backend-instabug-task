require 'kafka'

$kafka = Kafka.new('kafka:9092',client_id: 'app',logger: Rails.logger)


$kafka_producer = $kafka.producer


at_exit{ $kafka_producer.shutdown }

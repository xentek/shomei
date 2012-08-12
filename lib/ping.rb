class Ping
  include DataMapper::Resource

  property :id,         Serial
  property :machine,    String
  property :status,     String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :machine, :status
end

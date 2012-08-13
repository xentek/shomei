class Ping
  include DataMapper::Resource

  property :id,         Serial
  property :machine,    String
  property :status,     String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :machine, :status

  def button_css_class
    if status == 'failure'
      'alert'
    elsif status == 'success' and updated_at > (Time.now - (60*60))
      'success'
    else 
     'secondary'
    end
  end
end

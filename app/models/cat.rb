class Cat < ActiveRecord::Base
  COLORS = ["black", "white", "brown", "gray", "spotted", "OJ", "other"]
  SEX = ["M", "F"]
  validates :birth_date, :name, :color, :sex, presence: true
  validates :birth_date, :timeliness => 
      {:on_or_before => lambda { Date.current }, :type => :date}
      
  validates :color, inclusion: { in: COLORS, message: "%{value} is not a valid color" }
  
  validates :sex, inclusion: { in: SEX, message: "%{value} is not a valid sex"}
  

  def age
    days = (Date.today - birth_date).to_i
    (days / 365.25).to_i
  end
  
  def colors
    COLORS
  end
  
  def genders
    ["M", "F"]
  end
end

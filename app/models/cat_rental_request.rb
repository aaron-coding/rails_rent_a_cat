class CatRentalRequest < ActiveRecord::Base
  STATUSES = ["PENDING", "APPROVED", "DENIED"]
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { 
    in: STATUSES, message: "%{value} is not a valid status"
  }
  validate :no_overlapping_approved_requests
 
  belongs_to(
    :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id
  )
  
  after_initialize(
    :set_default_status
  )
  
  def set_default_status
    self.status ||= "PENDING"
  end
  
  def overlapping_requests 
    query = <<-SQL
    SELECT DISTINCT
      *
    FROM
    cat_rental_requests
    WHERE
    ((? BETWEEN start_date AND end_date)
    OR
    (? BETWEEN start_date AND end_date))
    AND
    id != ?
    SQL
    id_to_use = (self.id.nil? ? 0 : self.id)
    CatRentalRequest.find_by_sql([query, start_date, end_date, id_to_use])
  end
  
  def no_overlapping_approved_requests
    overlaps = overlapping_requests.select do |crr| 
      crr.status == "APPROVED"
    end
    
    unless overlaps.empty?
      errors[:request] << "can't overlap with an approved request"
    end
  end
  
end
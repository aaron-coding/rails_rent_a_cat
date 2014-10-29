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
  
  def approve!
    ActiveRecord::Base.transaction do
      self.status = "APPROVED"
      self.save!
      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
    
  end
  
  def deny!
    self.status = "DENIED"
    self.save!
  end
  
  def overlapping_requests 
    query = <<-SQL
    SELECT DISTINCT
      *
    FROM
    cat_rental_requests
    WHERE
      id != :id_to_use
    AND
      (((:start_date BETWEEN start_date AND end_date)
      OR
      (:end_date BETWEEN start_date AND end_date))
    OR
      ((start_date BETWEEN :start_date AND :end_date)
      OR 
      (end_date BETWEEN :start_date AND :end_date)))
    SQL
    id_to_use = (self.id.nil? ? 0 : self.id)
    CatRentalRequest.find_by_sql([query, {
      start_date: start_date,
      end_date: end_date, 
      id_to_use: id_to_use }])
  end
  
  def no_overlapping_approved_requests
    overlaps = overlapping_requests.select do |crr| 
      crr.status == "APPROVED"
    end
    
    if !(overlaps.empty?) && status == "APPROVED"
      errors[:request] << "can't overlap with an approved request"
    end
  end
  
  def overlapping_pending_requests
    overlaps = overlapping_requests.select do |crr| 
      crr.status == "PENDING"
    end
    overlaps
  end
  
end
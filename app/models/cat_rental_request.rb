class CatRentalRequest < ActiveRecord::Base
  STATUSES = ["PENDING", "APPROVED", "DENIED"]
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUSES, message: "%{value} is not a valid status"}
  
  
  def overlapping_requests

    
    query = <<-SQL
    SELECT DISTINCT
      *
    FROM
    cat_rental_requests AS a
    LEFT OUTER JOIN
    cat_rental_requests AS b
    ON
    a.cat_id = b.cat_id
    WHERE
    ((? BETWEEN b.start_date AND b.end_date)
    OR
    (? BETWEEN b.start_date AND b.end_date))
    AND
    a.id != b.id
    AND
    a.id != ?
    AND
    b.id != ?
    SQL
    
    CatRentalRequest.find_by_sql([query, start_date, end_date, id, id])
  end
  
  def overlapping_approved_requests
    
  end
  
end
#
# query = <<-SQL
# SELECT DISTINCT
#   a.*
# FROM
# cat_rental_requests AS a
# JOIN
# cat_rental_requests AS b
# ON
# a.cat_id = b.cat_id
# WHERE
# a.start_date BETWEEN b.start_date AND b.end_date
# AND
# a.id != #{self.id}
# SQL

#
# query = <<-SQL
# SELECT DISTINCT
#   *
# FROM
#   cat_rental_requests
# WHERE
#   start_date BETWEEN (start_date + 1) AND end_date
# AND
#   id != #{self.id}
# SQL
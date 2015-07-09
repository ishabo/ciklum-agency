# Bonus Model is used mainly used by the Service Model to create and store bonuses for users
class Bonus < ActiveRecord::Base
  self.table_name = 'bonuses'
  attr_accessible :bonus_scheme_id, :value, :claimed, :paid, :service_id, :project_id, :user_id, :eligibility, :payment_date, :due_month
  belongs_to :bonus_scheme
  belongs_to :project
  belongs_to :service
  belongs_to :user

  def self.statuses
    {potential: 1, won: 2, lost: 3}
  end

#  before_create :set_defaults

  def set_defaults
    self.claimed ||= false 
    self.paid ||= false
    self.eligibility ||= Bonus.statuses[:potential]
  end
 
  scope :where_service, -> (service) { where(:service_id => service.id) } 
  scope :where_project, -> (service) { where(:project_id => service.project.id) } 
  scope :where_bonus_scheme, -> (scheme) { where(:bonus_scheme_id => scheme.id) } 

  def eligibility_for_service_bonus
    # If this is a service bonus -> Service has to be paid
    status = :potential #if service.is_in_progress? || service.is_booked? 
    status = :won if service.is_completed? && service.is_paid
    status = :lost if service.is_lost?
    self.eligibility = Bonus.statuses[status]
    
  end

  def eligibility_for_project_bonus

    status = :potential
    status = :lost if project.is_lost?
    status = :won  if project.is_won? && service.is_paid  
    self.eligibility = Bonus.statuses[status] 
  end

  def self.find_bonus_for_service(service, bonus_scheme, bonus_winner)
    bonus = bonus_scheme.is_conversion? ? Bonus.where_project(service) : Bonus.where_service(service)
    bonus = bonus.where_bonus_scheme(bonus_scheme).first
    bonus = Bonus.create({
            user_id: bonus_winner.id,
            project_id: service.project.id,
            service_id: service.id,
            bonus_scheme_id: bonus_scheme.id,
            value: bonus_scheme.value,
            paid: false }) if !bonus 
    bonus
  end

  def update_bonus_eligibility

    if bonus_scheme.is_conversion?
      eligibility_for_project_bonus
    else
      eligibility_for_service_bonus
    end
    save!
    self
  end


  def self.destroy_bonus
    self.destroy
    return false
  end   
end

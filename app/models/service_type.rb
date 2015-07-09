class ServiceType < ActiveRecord::Base
  attr_accessible :name, :key_name

  def get_id(service_key_name)
  	get_service_type = ServiceType.find_by_key_name(service_key_name)
		raise "No #{service_key_name} Service Type Found in DB! Make sure Database is Seeded" if get_service_type == nil
		get_service_type.id
	end

	def get_ids(key_names)
		ServiceType.where(:key_name => key_names).map { |type| type.id }.compact
	end

	def get_ids_for_bonus(service_type)
		service_type == 'vas' ? 
				ServiceType.new.get_ids(['ws', 'ux', 'ttr']) : 
				[ServiceType.new.get_id( ApplicationHelper.is_conversion?(service_type) ? 'ws' : service_type)] << ServiceType.new.get_id('ttr') if service_type == 'ws'
	end
end

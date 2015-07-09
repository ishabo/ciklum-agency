module ApplicationHelper

	def get_months year
		#d1 = Date.parse(Rails.application.config.start_month)
		start_month = "#{year}-01-01"
		end_month = "#{Date.today.year}-12-31"
		d1 = Date.parse(start_month)
		d2 = Date.parse(end_month)
		(d1..d2).map{ |m| 
			m.beginning_of_month 
		}.uniq.map{ |m| 
			"%s %d" % [Date::ABBR_MONTHNAMES[m.month], m.year] 
		}
	end

	def self.is_conversion?(service_type)
		 service_type == 'conversion'
	end

	def self.this_year(format = '%Y')
		Date.today.strftime(format).to_i
	end

	def self.year_valid?(year)
		(2011..self.this_year()).include?(year)
	end

	def self.this_month(format)
		(DateTime.now).strftime(format)
	end

	def self.last_month(format)
		(DateTime.now - 1.month).strftime(format)
	end

	def self.next_month(format)
		(DateTime.now + 1.month).strftime(format)
	end

	def self.in_x_months(x, format)
		(DateTime.now + x.month).strftime(format)
	end



	def self.ensure_float int
		int.to_s.gsub(/[,\$]/,'').to_f
	end

	def self.comma_numbers(number, sign = '$', delimiter = ',')
  	if number == nil
    		num = 0
  	else
    		num = number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
  	end
  	
  	return "#{sign}#{num}"
	end

  def self.form_hub_link(hub_id)
    ActionController::Base.helpers.link_to 'HUB', "http://hub.ciklum.net/project/#{hub_id}", {:target => '_blank', :class => 'icon-filter'}
  end

  def self.filtr_by(filter, text, value)
 		ActionController::Base.helpers.link_to text, "#{Rails.application.routes.url_helpers.services_path()}##{filter}=#{value}"
 	end

 	def self.list_projects (project, list = '')
		 "#{list} - #{self.filtr_by('project', project, project)}</br>".html_safe
	end
					
	def self.calc_conversion_date (won, lost)
		"#{((won*100)/(won+lost)).round}%"
	end

	def self.is_mysql?
		ActiveRecord::Base.connection.adapter_name == 'MySQL'
	end

	def self.factorial(num)
		(1..num).inject(:*) || 1
	end
end

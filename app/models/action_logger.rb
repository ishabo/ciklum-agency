class ActionLogger

	def initialize(session)
      @session = session
      @action = ""
    end

	def after_create record
  		@action = "created a new object:"
  		self.compile_info(record)
	end

	def after_update record
  		@action = "updating to "
  		self.compile_info(record, true)
	end

	def before_destroy record
  		@action = "destroyed object:"
  		self.compile_info(record)
	end

	def basic_info
		"[#{DateTime.now.strftime('%H:%M:%S')}]:"
	end

	def compile_info record, updating = false
		old_rec = {}
		new_rec = {}
		if updating
			record.methods.each do |method|
				if /^[a-z_]+_was$/.match(method)
					old_rec[method] = record.send(method)
					new_method = method.to_s.sub! /_was/, ''
					new_rec[new_method] = record.send(new_method)
				end
			end
		end 
		if old_rec != {}
			record_info = "Updating: #{record.class.to_s} from #{old_rec.to_json}\nTO\n#{new_rec.to_json}"
		else	
			record_info = "#{@action} #{record.to_json}"
		end
		logger.info("#{basic_info} #{record_info}\n----------------------------------------\n")
	end

	def current_user
		abort @session[:user_id].to_s
		@current_user ||= User.find(@session[:user_id]) if @session[:user_id]
	end

	def logger
		path = "#{Rails.root}/log/#{DateTime.now.strftime('%Y-%m-%d')}/"
		FileUtils.mkdir_p(path) unless File.exists?(path)
		@logger ||= Logger.new("#{path}/#{current_user.name}.log")
	end

end	
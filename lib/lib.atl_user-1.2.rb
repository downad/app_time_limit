##############################################
## Methoden für die User-Steuerung
##############################################

def does_user_exist(user)
	return @atl_user.include?(user) 
end

def set_user(user)
	if @atl_user.include?(user) == false
		#atl_user["default"] = ATLUser.new("default", true, 32, 30, false)
		atl_user[user] = ATLUser.new(user, true, 32, 30, false)
	end
	#atl_user.each_key { |key| puts atl_user[key].print_atl_user } if @debugging_on == true
end

def get_resticted_user
	resticted_user = Array.new
	@atl_user.each_key { |key| 
		if @atl_user[key].is_atl_status_resticted == true
			resticted_user << @atl_user[key].get_atl_user 
		end
	}
	puts "resticted_user = #{resticted_user}" if @debugging_on == true
	return resticted_user
end

def get_exit_button_user
	exit_button_user = Array.new
	@atl_user.each_key { |key| 
		if @atl_user[key].is_exit_button_user == true
			exit_button_user << @atl_user[key].get_atl_user 
		end
	}
	puts "exit_button_user = #{exit_button_user}" if @debugging_on == true
	return exit_button_user
end



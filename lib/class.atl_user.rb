class ATLUser
=begin
# USER  = Array ["restricted: yes/no", "hardlimit: 90min", "softlimit: 60min", "Exit-Button: yes/no"] 
atc_user["ralf"] =  [false, 90, 90, true]
atc_user["jac"] =  [true, 120, 90, true]
atc_user["lara"] =  [true, 65, 60, false]
atc_user["coralie"] =  [true, 65, 60, false]
=end
	def initialize(name, restricted = true, hardlimit = 30, softlimit = 30, exit_button_user = false)
		@atl_user = name
		@is_atl_status_resticted = restricted
		@hardlimit = hardlimit
		# softlimit <= hardlimit
		softlimit > hardlimit ? @softlimit = hardlimit :  @softlimit = softlimit  
		@is_exit_button_user = exit_button_user
	end

	def get_atl_user
		return @atl_user
	end
	
	def is_atl_status_resticted
		return @is_atl_status_resticted
	end
	
	def get_hardlimit
		return @hardlimit
	end

	def get_softlimit
		return @softlimit
	end
	
	def is_exit_button_user
		return @is_exit_button_user
	end
	
	def print_atl_user
		returnstring = ""
		returnstring << " ##########################################################################"
		returnstring << "\n atl_user (#{@atl_user})"
		returnstring << "\n is_atl_status_resticted - #{@is_atl_status_resticted}"
		returnstring << "\n @hardlimit - #{@hardlimit}"
		returnstring << "\n @softlimit - #{@softlimit}"
		returnstring << "\n @is_exit_button_user - #{@is_exit_button_user}"
		returnstring << "\n ##########################################################################"
		return returnstring 
	end
	
end

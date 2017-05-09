class ApiController < ApplicationController
	protect_from_forgery with: :null_session
	def hostname
		serial = params[:serial]
		machine = Machine.where(serial_number: serial)[0]
		hostname = {}
		if machine
			if machine[:role]
				role = Role.where(name: machine[:role])[0]
				if machine[:location]
					school = School.where(name: machine[:location])[0]
					if school[:blended_learning] && school[:blended_learning] == true
						render json: {'hostname' => "#{school[:school_code]}#{role[:suffix]}BL-#{machine[:serial_number]}"}
					else
						render json: {'hostname' => "#{school[:school_code]}#{role[:suffix]}LT-#{machine[:serial_number]}"}
					end
				else
					render json: {"error" => "No school found for machine"}
				end
			else
					render json: {"error" => "No role found for machine"}
			end
		else
			render json: {"error" => "No machine found for serial"}
		end
	end

	def image
		serial = params[:serial]
		machine = Machine.where(serial_number: serial)[0]
		if machine
			school = School.where(name: machine[:location])[0]
			if school
				role = machine[:role]
				if role
					if school[:blended_learning] && school[:blended_learning] == true
						render json: {'image-name' => "blended_learning/#{ role.downcase }"}
					else
						render json: {'image-name' => "standard/#{role.downcase}"}
					end
				else
					# no role
					render json: {"error" => "No role found for machine"}
				end
			else
				# no school
				render json: {"error" => "No school found for machine"}
			end
		else
			render json: {"error" => "No machine found for serial"}
		end
	end

	def index

	end
	end
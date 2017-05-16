class ApiController < ApplicationController
	protect_from_forgery with: :null_session
	def hostname
		serial = params[:serial]
		machine = Machine.where(serial_number: serial)[0]
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

	def mark_as_deployed
		serial = params[:serial]
		app_key = Rails.configuration.api['key']
		sent_key = params[:key]
		machine = Machine.where(serial_number: serial)[0]
		if machine
			school = School.where(name: machine[:location])[0]
			if school
				role = machine[:role]
				if role
					if sent_key == app_key
						machine.update(deployed: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "deployed" => true}, doa: false)
						render json: {"message" => "Successfully marked as deployed"}
					else
						render json: {"error" => "Invalid key"}
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

	def set_asset_tag
		serial = params[:serial]
		asset_tag = params[:asset_tag]
		machine = Machine.where(serial_number: serial)[0]
		if machine
			school = School.where(name: machine[:location])[0]
			if school
				role = machine[:role]
				if role
					if asset_tag
						machine.update(client_asset_tag: asset_tag )
						render json: {"message" => "Successfully set asset tag"}
					else
						# no tag
						render json: {"error" => "No asset tag passed"}
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
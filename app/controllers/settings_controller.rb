class SettingsController < ApplicationController
	before_action :authenticate_user! 
	before_action :check_own_user, only: [:show, :edit, :update]

	def index
		settings = Setting.where(user_id: current_user.id)
		if settings.empty?
			# Create a default setting (should be done when user is created but dont want to mess with devise)
			setting = Setting.create({user_id: current_user.id})
			setting_id = setting.id
		else
			# there must be a setting for this user already, we enforce 1 setting per user so only one possible record
			setting_id = settings.first.id
		end

		params[:id] = setting_id
		set_setting
		redirect_to @setting
	end

  def show
		set_setting
  end

  def new
    @setting = Setting.new({user_id: current_user.id})
  end

  def edit
		set_setting
  end

  def create
    @setting = Setting.new({user_id: current_user.id})
    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
		set_setting
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:hsk_level, :grammar_level)
    end


    # Dont let a logged-in user edit or see others parameters but his own
		def check_own_user
      @url_setting = Setting.find(params[:id])
			redirect_to root_path unless @url_setting.user.id == current_user.id 
		end

end

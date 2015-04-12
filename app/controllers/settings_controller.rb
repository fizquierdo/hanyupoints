class SettingsController < ApplicationController
	before_action :authenticate_user! 
	# TODO you should only be able to change your own settings

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

end

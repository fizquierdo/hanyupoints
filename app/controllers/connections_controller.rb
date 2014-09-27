class ConnectionsController < ApplicationController
  before_action :set_connection, only: [:show, :edit, :update, :destroy]

  # GET /connections
  # GET /connections.json
  def index
    @connections = Connection.all
  end

  # GET /connections/1
  # GET /connections/1.json
  def show
  end

  # GET /connections/new
  def new
    @connection = Connection.new
    @words = Word.all
  end

  # GET /connections/1/edit
  def edit
  end

  # POST /connections
  # POST /connections.json
  def create
    @connection = Connection.new(connection_params)
    @words = Word.all
	
    respond_to do |format|
      if @connection.save
        format.html { redirect_to @connection, notice: 'Connection was successfully created.' }
        format.json { render :show, status: :created, location: @connection }
      else
        format.html { render :new }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connections/1
  # PATCH/PUT /connections/1.json
  def update
    respond_to do |format|
      if @connection.update(connection_params)
        format.html { redirect_to @connection, notice: 'Connection was successfully updated.' }
        format.json { render :show, status: :ok, location: @connection }
      else
        format.html { render :edit }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.json
  def destroy
    @connection.destroy
    respond_to do |format|
      format.html { redirect_to connections_url, notice: 'Connection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def connection_params
      params.require(:connection).permit(:from, :to, :color, :directional)
    end
end

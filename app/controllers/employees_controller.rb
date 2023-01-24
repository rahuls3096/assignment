class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
      file = employee_params[:file]
      file_ext = File.extname(file.original_filename)
      spreadsheet =  Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
      spreadsheet.row(1).map!(&:downcase!)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        combined_data = Hash[header.zip(spreadsheet.row(i))]
        @employee = Employee.new(combined_data)
        @employee.company_id = params[:employee][:company_id]
      end
      
    respond_to do |format|
      if @employee.save
        format.html { redirect_to @company, notice: @message }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :new, notice: @message }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
    # respond_to do |format|
    #   format.js {}
    # end
  end


  def update
    @company = @employee.company
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @company, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    # byebug
    @company = @employee.company
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to @company, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:name, :gender, :email, :age, :contact_no, :company_id, :file)
    end
end

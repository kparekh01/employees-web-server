class EmployeesController < ApplicationController

  def show
    @employee = Employee.find_by(id: params[:id]) #Employee.find_by(id: params[:id]) is the same as self.find_by(options) in the model
  end

  def index
  @employees = Employee.all
  @employees = @employees.sort_by{|employee| employee.id}
  end

  def new
  end

  def create
  employee = Unirest.post("http://localhost:3000/api/v1/employees",
                          headers:{ "Accept" => "application/json" },
                          parameters:{ :first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email]}
                          ).body
          redirect_to "employees/#{employee["id"]}"
  end

  def edit
    @employee = Unirest.get("http://localhost:3000/api/v1/employees/#{params[:id]}.json").body
  end

  def update
    @employee = Employee.find_by(id: params[:id]).update(params)
    render 'show'
  end

  def destroy
    @employee = Employee.find_by(id: params[:id]).destroy
    redirect_to '/employees'
  end
end

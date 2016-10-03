class Employee
  attr_accessor :first_name, :last_name, :email
  attr_reader :id

  def initialize(input)
    @first_name = input["first_name"]
    @last_name = input["last_name"]
    @email = input["email"]
    @id = input["id"]
  end

  def full_name
    @first_name + " " + @last_name
  end
                            #Employee.find_by(id: params[:id]) in the controller is being replaced with self.find_by(options) here.
  def self.find_by(options) #Options is a hash that holds just one key value pair options = {id: => params[id] }
    hash = Unirest.get("http://localhost:3000/api/v1/employees/#{options[:id]}.json").body
    self.new(hash)
  end

  def self.all
    api_employees = Unirest.get("http://localhost:3000/api/v1/employees.json",
    headers: {
      "Accept" => "application/json",
      "X-User-Email"=> "rblake01@gmail.com",
      "Authorization" => "Token token=Thisisanapi_key"
      }).body
    api_employees.map{|employee| Employee.new(employee)} #map returns an array of new instances of Employee class
  end

  def destroy
    Unirest.delete("http://localhost:3000/api/v1/employees/#{id.to_s}.json").body #instance method id which holds the id number of input hash
                                                                                  #and input is the hash given when initializing new instance
  end

  def update(params)
    hash = Unirest.patch("http://localhost:3000/api/v1/employees/#{id.to_s}",
                            headers:{ "Accept" => "application/json" },
                            parameters:{ first_name: params[:first_name], last_name: params[:last_name], email: params[:email]}
                            ).body
    Employee.new(hash)
  end


end

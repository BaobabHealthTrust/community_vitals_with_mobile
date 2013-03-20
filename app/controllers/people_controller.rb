
class PeopleController < ApplicationController

  before_filter :check_login, :except => [:login, :check_login, :account_login, 
    :get_first_names, :get_last_names, :get_names, :load_all_people]
  
  def load_all_people
    result = {}

    Person.all.each do |p|

      result[p.person_id] = {
        "id" => p.person_id,
        "first_name" => p.first_name,
        "middle_name" => (!p.middle_name.blank? ? p.middle_name : "&nbsp;"),
        "last_name" => p.last_name,
        "gender" => p.gender,
        "dob" => p.date_of_birth,
        "occupation" => p.occupation,
        "outcome" => ((p.outcomes.length > 0 ? p.outcomes.last.type.name : "&nbsp;")),
        "outcome_date" => (p.outcomes.last.outcome_date rescue "&nbsp;"),
        "date_created" => (!p.date_created.blank? ? p.date_created : "&nbsp;"),
        "identifiers" => (p.identifiers.map{|id| id.identifier}.join("<br/>") + "&nbsp;" rescue "&nbsp;"),
        "relations" => (p.relationships.collect{|rl| 
            "#{rl.relative.first_name} #{rl.relative.last_name} (#{rl.type.name})"
          }.join("<br/>") + "&nbsp;")
      }
    end

    render :text => result.to_json
  end

  def get_first_names
    names = Person.all(:conditions => ["first_name LIKE ?", "#{params["search"]}%"]).collect{|p|
      [p.first_name, p.first_name]
    }.uniq

    render :text => names.to_json
  end

  def get_last_names
    names = Person.all(:conditions => ["last_name LIKE ?", "#{params["search"]}%"]).collect{|p|
      [p.last_name, p.last_name]
    }.uniq

    render :text => names.to_json
  end

  def get_names
    names = Person.all(:conditions => ["first_name LIKE ? AND last_name LIKE ? AND gender = ?",
        "#{params["fname"]}%", "#{params["lname"]}%", "#{params["sex"]}"]).collect{|p|
      ["#{p.first_name} #{p.last_name} (#{p.gender} - DOB: #{p.date_of_birth})", p.person_id]
    }.uniq

    render :text => names.to_json
  end

  def index
    render :layout => false
  end

  def add_person

  end

  def edit_person

  end

  def check_login
    u = User.getToken

    if u.nil?
      redirect_to "/people/login" and return
    end
  end

  def login

  end

  def account_login
    session[:locale] = params["1.1"]
    session[:cat] = params["1.4"].to_i

    user = User.authenticate(params["1.2"], params["1.3"])

    unless !user
      redirect_to "/people/index?l=#{params["1.1"]}&cat=#{params["1.4"]}" and return
    else
      redirect_to "/people/login" and return
    end
  end

  def logout
    User.logout
    
    redirect_to "/people/login"
  end

  def messages

  end

  def post_demographics

  end

  def relationships

  end

  def reports

  end

  def update_outcome    
  end

  def updateOutcome
    t = OutcomeType.find_by_name(params["1.5"]) # .id rescue nil
    
    months = {
      "January" => "01",
      "February" => "02",
      "March" => "03",
      "April" => "04",
      "May" => "05",
      "June" => "06",
      "July" => "07",
      "August" => "08",
      "September" => "09",
      "October" => "10",
      "November" => "11",
      "December" => "12",
      "Unknown" => "?"
    }

    unless t.nil?
      outcome_date = nil
      explanation = nil
      
      case params["1.5"].downcase
      when "dead"
        outcome_date = "#{params["1.6"]}-#{months[params["1.7"]]}-#{(!params["1.8"].blank? ? params["1.8"] : "?")}"
        explanation = params["1.9"]
      when "transfer out"
        outcome_date = "#{params["1.10"]}-#{months[params["1.11"]]}-#{(!params["1.12"].blank? ? params["1.12"] : "?")}"
      when "transfer back"
        outcome_date = "#{params["1.13"]}-#{months[params["1.14"]]}-#{(!params["1.15"].blank? ? params["1.15"] : "?")}"
      end
      o = Outcome.new(
        :outcome_type_id => t.outcome_type_id,
        :outcome_date => outcome_date,
        :explanation => explanation,
        :date_created => Date.today.strftime("%Y-%m-%d"),
        :person_id => params["1.4"].to_i
      )

      o.save

    end

    redirect_to "/people/index"
  end

  def savePersonRelationship
    r = RelationshipType.find_by_name(params["1.9"])

    unless r.nil?
      p = Relationship.new(
        :person_a_id => params["1.4"].to_i,
        :person_b_id => params["1.8"].to_i,
        :relationship_type => r.id,
        :date_created => Date.today.strftime("%Y-%m-%d")
      )

      p.save
    end

    redirect_to "/people/index"
  end

  def saveEditedPerson
    t = PersonIdentifierType.find_by_name(params["1.5"])

    unless t.nil?
      p = PersonIdentifier.new(
        :person_id => params["1.4"].to_i,
        :identifier => params["1.6"],
        :identifier_type => t.id,
        :date_created => Date.today.strftime("%Y-%m-%d")
      )

      p.save
    end
  end

  def addPerson
    months = {
      "January" => "01",
      "February" => "02",
      "March" => "03",
      "April" => "04",
      "May" => "05",
      "June" => "06",
      "July" => "07",
      "August" => "08",
      "September" => "09",
      "October" => "10",
      "November" => "11",
      "December" => "12",
      "Unknown" => "?"
    }
    
    unless params["1.6"].blank?
      d = Date.today.year - params["1.6"].to_i
      
      dob = ((d.to_s + "-?-?") rescue nil)
    else
      dob = ((params["1.5"] + "-" + (months[params["1.7"]] rescue "?") + "-" + 
            (params["1.8"].downcase == "unknown" ? "?" : params["1.8"] )) rescue nil)
    end
    
    p = Person.new(
      :first_name => (params["1.1"] rescue nil),
      :middle_name => (params["1.2"] rescue nil),
      :last_name => (params["1.3"] rescue nil),
      :gender => (params["1.4"] rescue nil),
      :date_of_birth => dob,
      :year_of_birth => (params["1.5"] rescue nil),
      :month_of_birth => (params["1.7"] rescue nil),
      :day_of_birth => (params["1.8"] rescue nil),
      :occupation => (params["1.9"] rescue nil),
      :date_created => Date.today.strftime("%Y-%m-%d")
    )

    p.save
    
    redirect_to "/people/index"
  end

end
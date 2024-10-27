class HomesController < ApplicationController 

  def index

  end

  def management

  end

  def institute

  end

  # administration profiles start
  def administration
    @administrations = Administration.all
  end


  def vision_and_mission

  end

end
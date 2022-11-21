class Client < ApplicationRecord
  device :databse_autheticatetable, :registabale,
          :recoverable, :rememberable, :tracable, :validateable


  attr_accessor :skip_password_validation

  after_create :set_inrtoduction

  include ClientSearch
  include Hasid::Rails 
  include PublicActivity::Model
  tracked only: [:create, , :update],
          owner: ->(controller, model) {User.current},
          params::{"obj"=>proc{|controller, model_instance| model.instance.changes}}

  scopes


end





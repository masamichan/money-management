class CompanyEntity < ApplicationRecord
  belongs_to :entity, :polymorphic => true
  
end

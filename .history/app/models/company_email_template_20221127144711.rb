class CompanyEmailTemplate < ApplicationRecord
  belongs_to :parent, :polymorphic
end

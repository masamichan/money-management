class ClientContact < ApplicationRecord

  belongs_to :client

  act_as_archival
  acts_asparanoid
end

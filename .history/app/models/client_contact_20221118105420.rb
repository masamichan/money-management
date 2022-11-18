class ClientContact < ApplicationRecord

  belongs_to :client

  acts_as_archival
  acts_as_paranoid
end

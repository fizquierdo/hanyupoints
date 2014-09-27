class Connection < ActiveRecord::Base
	validates :from, presence: true
	validates :to,   presence: true

	validate :from_available, on: :create
	validate :to_available,   on: :create

	def from_available
	  errors.add(:from, "#{from} not present in the DB") if Word.all.find_by_han(from).nil?
	end
	def to_available
	  errors.add(:to, "#{to} not present in the DB") if Word.all.find_by_han(to).nil?
	end

	def to_generic_json
		'["' + self.from + '","' +self.to+ '",{color:"#00A0B0",directional:'+ self.directional.to_s+'}],'
	end
end

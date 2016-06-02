class Review < ActiveRecord::Base

	belongs_to :book
	belongs_to :reader

	def content=(content)
		if content.blank?
			super(nil)
		else
			super(content)
		end
	end
	

end

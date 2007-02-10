class ChangelogController < ApplicationController
	before_filter :authenticate_char_admin

	def index
	end
end

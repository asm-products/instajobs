class FbSignupMailer < ApplicationMailer
	default :from => "ashesh.vidyut@gmail.com"
	def password(user)
		@user = user
		@password = user.password
		mail(to: user.email, subject: "InstaJob password")
	end
end

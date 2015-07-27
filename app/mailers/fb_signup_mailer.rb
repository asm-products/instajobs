class FbSignupMailer < ApplicationMailer
	default :from => "support@instajob.io"
	def password(user)
		@user = user
		@password = user.password
		mail(to: user.email, subject: "InstaJob password")
	end
end

class SignupMailer < ApplicationMailer
	default :from => "support@instajob.io"
	def signup_link(user)
		@user = user
		@link = ENV["DOMAIN"]+"verify?token=" + @user.email_verify_token; 
		mail(to: user.email, subject: "InstaJob Email Verification")
	end
end

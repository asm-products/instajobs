class SignupMailer < ApplicationMailer
	default :from => "ashesh.vidyut@gmail.com"
	def signup_link(user)
		@user = user
		@link = "http://vagrant.com:3000/verifymail?token=" + @user.email_verify_token; 
		mail(to: user.email, subject: "InstaJob Email Verification")
	end
end

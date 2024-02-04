import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Set your SMTP server and credentials
smtp_server = 'smtprelay.unimedbh.com.br'
#smtp_port = 465  # Use the appropriate port for your server
smtp_port = 587
smtp_username = 'smtp.app.sate.hml'
smtp_password = 'bx#Xm$7x=c7H#bC%@HEDX$'
smtp = smtplib.SMTP_SSL(smtp_server, smtp_port)  # For SSL
# Set sender and recipient email addresses
sender_email = 'sate@example.com'
recipient_email = 'alan.aguinaga@csiway.com.br'

# Create a message object
subject = 'Test Email'
body = 'This is a test email sent from your application.'
message = MIMEMultipart()
message['From'] = sender_email
message['To'] = recipient_email
message['Subject'] = subject
message.attach(MIMEText(body, 'plain'))

# Connect to the SMTP server and send the email
try:
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()  # Use TLS (optional)
        server.login(smtp_username, smtp_password)
        server.sendmail(sender_email, recipient_email, message.as_string())
    print('Test email sent successfully!')
except Exception as e:
    print(f'Error: {e}')

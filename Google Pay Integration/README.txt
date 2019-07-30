Concept:
     these scripts allow Shelby arena to send a member barcode to the congregation. it can be used for all check in purposes and requires a 2d barcode scanner.
     **security warning** using this module is susceptible to webpage modification, do not use this anywhere but the staff website

INSTRUCTIONS
follow all the instructions on the google website and replace all fields with your churches information or it will not work
modify the contents of the "CreateClass" folder and the stored procedures to represent your churches google settings

launch the createClass/index.html webpage and follow the prompt to create the base class
IF and only IF it is created successfully and you can see the class in google pay mercent center you can proceed to the arena stored procedures

the HTML stored procedures are to be placed as tabs in the member details page of arena



Resources:
     loyaltycass: https://developers.google.com/pay/passes/reference/v1/loyaltyclass
          used for creating the template of the loyalty card
     Save to google pay: https://developers.google.com/pay/passes/guides/get-started/implementing-the-api/save-to-google-pay#add-link-to-email-sms
          guide on implementing the google pay api
     Google managment pages
          merchant: https://merchants.google.com/mc/users?a=133090558&pli=1
          google api: https://console.developers.google.com/iam-admin/iam?project=my-project-1519158445096&organizationId=0&pli=1

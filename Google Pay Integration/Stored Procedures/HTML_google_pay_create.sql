USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[lumiante_HTML_sp_google_pay_managment]    Script Date: 7/30/2019 10:50:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_lumiante_HTML_sp_google_pay_create]
@OrganizationID INT,
@SelectedPerson INT
AS

BEGIN

DECLARE @fname VARCHAR(50) = (SELECT first_name from core_person where person_id = @SelectedPerson)
DECLARE @lname VARCHAR(50) = (SELECT last_name from core_person where person_id = @SelectedPerson)
DECLARE @phone VARCHAR(50) = (SELECT TOP 1 phone_number from core_person_phone where person_id = @SelectedPerson order by phone_number desc)
DECLARE @Results VARCHAR(MAX) --the end result

/** Put the strings together!!! **/
--enter string parts here
SELECT @Results = ('
<div class="creative_project_name">
     <style>
          .button{
			 background-color: black;
			 color: white;
			 text-decoration: none;
			 padding: 2pt 5pt;
			 margin: 5pt;
			 border-radius: 5pt;
		}
		.button:hover{
			 background-color: #AAA;
			 color: white;
		}
		.hidden{
			 display: none;
			 opacity: 0;
		}
     </style>
     <h1 class="title">Arena Check-In Testing for: '+@fname+' '+@lname+'</h1>

<br><br>
<p>
     classes can be managed at <a href="https://pay.google.com/gp/m/issuer/3336206256661903001">Google Pay Merchant Center</a>
</p>
<a href="#button3" id="button3" onClick="play()" class="button">Google Play</a>
<br><br>
<div id="out"></div>
<textarea class="hidden" id="privkey" rows="28" cols="68">-----BEGIN PRIVATE KEY-----
     REDACTED FOR SECURITY REASONS
     -----END PRIVATE KEY-----</textarea>

<script src="https://kjur.github.io/jsrsasign/jsrsasign-latest-all-min.js"></script>
<script type="text/javascript">
//Global Variables
     var out = document.getElementById("out"); //an output block to show the final JWT FOR TESTING
     var pkey = document.getElementById("privkey").innerHTML; //the primary key
     var token; //the access token

     function play(){
          token();
          newObject();
     }
//this block sends the JWT and recieves a token
     function token(){
          //variable decloration
          var ts = Math.round((new Date()).getTime() / 1000); //gets current time in seconds from 1 1 1970
          var ts_min = ts+60; //the experation time of the the token in seconds from 1 1 1970
          var oHeader = {alg: "RS256", typ: "JWT"}; //the headder
          var oPayload = {}; //the boddy
          oPayload.iss = "arena-check-in@check-in-236000.iam.gserviceaccount.com";
          oPayload.scope = "https://www.googleapis.com/auth/wallet_object.issuer";
          oPayload.aud = "https://www.googleapis.com/oauth2/v4/token";
          oPayload.exp = ts_min.toString();
          oPayload.iat = ts.toString();

          //this block signes and packages the Oauth JWT
          var sHeader = JSON.stringify(oHeader);
          var sPayload = JSON.stringify(oPayload);
          var newPkey = KEYUTIL.getKey(pkey);
          var sJWT = KJUR.jws.JWS.sign("RS256", sHeader, sPayload, newPkey);

          const data={
               grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
               assertion: sJWT
          }
          $.post("https://www.googleapis.com/oauth2/v4/token", data, function(data, status){
               token = data;
               console.log("New Token Generated:");
          });
     }
//this block posts a Loyalty Class
     function newClass(){
          const sdata ={
               "iss": "arena-check-in@check-in-236000.iam.gserviceaccount.com",
               "iat": ts.toString(),
               "accountIdLabel": "Member Id",
               "accountNameLabel": "Member Name",
               "id": "3336206256661903001.LuminateChurch",
               "issuerName": "LuminateChurch",
               "kind": "walletobjects#loyaltyClass",
               "textModulesData": [
                    {
                         "header": "Members Code",
                         "body": "Thank you for attending Luminate Church"
                    }
               ],
               "linksModuleData": {
                    "uris": [
                         {
                              "kind": "walletobjects#uri",
                              "uri": "tel:6269664488",
                              "description": "Call Customer Service"
                         }
                    ]
               },
               "imageModulesData": [
                    {
                         "mainImage": {
                              "kind": "walletobjects#image",
                              "sourceUri": {
                                   "kind": "walletobjects#uri",
                                   "uri": "https://farm4.staticflickr.com/3738/12440799783_3dc3c20606_b.jpg",
                                   "description": "Coffee beans"
                              }
                         }
                    }
               ],
               "messages": [{
                    "header": "Welcome to Luminate Church",
                    "body": "Featuring our new bacon donuts.",
                    "kind": "walletobjects#walletObjectMessage"
               }],
               "locations": [{
                    "kind": "walletobjects#latLongPoint",
                    "latitude": 34.090009,
                    "longitude": -117.886693
               }],
               "programLogo": {
                    "kind": "walletobjects#image",
                    "sourceUri": {
                         "kind": "walletobjects#uri",
                         "uri": "https://farm8.staticflickr.com/7340/11177041185_a61a7f2139_o.jpg"
                    }
               },
               "programName": "Check In",
               "reviewStatus": "underReview",
               "hexBackgroundColor": "#ffffff",
               "heroImage": {
                    "kind": "walletobjects#image",
                    "sourceUri": {
                         "kind": "walletobjects#uri",
                         "uri": "https://farm8.staticflickr.com/7302/11177240353_115daa5729_o.jpg"
                    }
               }
          };

          $.ajax({
               type: "post",
               url: "https://www.googleapis.com/walletobjects/v1/loyaltyClass",
               datatype: "json",

               headers: {
                    "Authorization": "Bearer " +token.access_token,
                    "Content-Type" : "application/json ; charset=UTF-8"
               },
               data: JSON.stringify(sdata),
               success: function (){
                    console.log("Cheers!");
               }

          });
     }
//this block makes a new loyalty class object link
     function newObject(){
          //variable decloration
          var ts = Math.round((new Date()).getTime() / 1000); //gets current time in seconds from 1 1 1970
          var ts_min = ts+60; //the experation time of the the token in seconds from 1 1 1970
          var oHeader = {alg: "RS256", typ: "JWT"}; //the headder
          var oPayload = {}; //the boddy
          oPayload.iss = "arena-check-in@check-in-236000.iam.gserviceaccount.com";
          oPayload.aud = "google";
          oPayload.typ = "savetoandroidpay";
          oPayload.iat = ts.toString();
          oPayload.payload = {
               "loyaltyObjects": [{
                    "classId" : "3336206256661903001.LuminateChurch",
                      "id" : "3336206256661903001.'+CONVERT(varchar(50),@SelectedPerson)+'",
                      "accountId": "'+CONVERT(varchar(50),@SelectedPerson)+'",
                      "accountName": "'+@fname+' '+@lname+'",
                      "barcode": {
                          "alternateText" : "'+@phone+'",
                          "type" : "qrCode",
                          "value" : "P'+CONVERT(varchar(50),@SelectedPerson)+'"
                      },
                      "state": "active",
                      "version": 1
               }]
          };
          oPayload.origins = ["https://arena.luminate.church"];
          //this signes and makes the JWT
          var sHeader = JSON.stringify(oHeader);
          var sPayload = JSON.stringify(oPayload);
          var newPkey = KEYUTIL.getKey(pkey);
          var sJWT = KJUR.jws.JWS.sign("RS256", sHeader, sPayload, newPkey);
          //creates a link to be sent out
          out.innerHTML = "<a href=https://arena.luminate.church/default.aspx?page=3472&ID='+CONVERT(VARCHAR(50),@SelectedPerson)+'&sjwt="+sJWT+" >send the email</a> ";
     }
</script>



</div>

')

SELECT @Results AS [html]

END

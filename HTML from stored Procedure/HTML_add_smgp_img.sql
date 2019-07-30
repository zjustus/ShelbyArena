USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[lumiante_HTML_sp_add_smgp_img]    Script Date: 7/30/2019 9:53:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_add_smgp_img]
@OrganizationID INT

AS

BEGIN

DECLARE @Results VARCHAR(MAX) --the end result

/** small tags **/
DECLARE @container_start VARCHAR(2000) = (SELECT '<div class="container" style="display: none;">')
DECLARE @div VARCHAR(20) = (SELECT '<div>')
DECLARE @div_close VARCHAR(20) = (SELECT '</div>')


/** make the img tag **/
DECLARE @img VARCHAR(MAX)
SELECT @img = COALESCE(@img + A, A) FROM (SELECT
'<div class="col-xm-12 col-md-6" id="img'+CONVERT(VARCHAR(50),group_id)+'" >
	<img width=100% src="CachedBlob.aspx?guid='+ CONVERT(VARCHAR(100),blob.guid) + '">
</div>'
AS A FROM [dbo].[smgp_group] AS smgp left join [dbo].[util_blob] AS blob ON [smgp].[image_blob_id] = [blob].[blob_id] WHERE group_cluster_id = 17) AS contentA WHERE A is not NULL


/** make the groupDetails string for JS **/
DECLARE @groupDetails VARCHAR(MAX)
SELECT @groupDetails = COALESCE(@groupDetails + B, B) FROM (SELECT
'"group'+CONVERT(VARCHAR(50),group_id)+'details", '
as B FROM [dbo].[smgp_group] AS smgp WHERE group_cluster_id = 17) AS contentB WHERE B is not NULL

/** make the imgDetail string for JS **/
DECLARE @imgDetails VARCHAR(MAX)
SELECT @imgDetails = COALESCE(@imgDetails + C, C) FROM (SELECT
'"img'+CONVERT(VARCHAR(50),group_id)+'", '
as C from [dbo].[smgp_group] AS smgp WHERE group_cluster_id = 17) AS contentC WHERE C is not NULL



/** the magic script**/
DECLARE @script VARCHAR(MAX) = (SELECT '
<script type="text/javascript">
	window.addEventListener("load", pageFullyLoaded, false);
	function pageFullyLoaded(e){

	//the groups
		var groups = ['+@groupDetails+'""];
		var details = new Array();

		//the images
		var imgs = ['+@imgDetails+'""];
		var imgDetails = new Array();

		var i; var j;
		//populate the img array
		for(i = 0; i < imgs.length; i++){
			if(imgs[i] != "" && document.getElementById(imgs[i])){
				imgDetails.push(document.getElementById(imgs[i]));
			}
		}

		//populates the groups array then adds in the elements
		for(i = 0; i < groups.length-1; i++){
			if(groups[i] != ""){
				details.push(document.getElementById(groups[i]));
			}
			var detailsID = details[i].id;
			detailsID = detailsID.replace(/group|details/g, "");

			for(j = 0; j < imgDetails.length; j++){ //adds imamages
				var imgID = imgDetails[j].id;
				imgID = imgID.replace(/img/g, "");

				if(detailsID == imgID){ //img validation
					var cln = imgDetails[j].cloneNode(true);
					details[i].firstElementChild.firstElementChild.appendChild(cln);
					break;
				}
			}
		}
		document.getElementById("ctl05_lblPageTitle").innerHTML = "Dinner Parties";
	}
</script>
')

/** Put the strings together!!! **/
SELECT @Results = (
	@container_start + @img + @div_close + @script

)

SELECT @Results AS [html]

END

SELECT * FROM dbo.core_person_phone

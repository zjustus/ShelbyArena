--query that selects the approved bulliton requests for the current week

SELECT title, summary
FROM
	dbo.mktg_promotion_request_bulletin as bul
	LEFT JOIN dbo.mktg_promotion_request as req on req.promotion_request_id = bul.promotion_request_id
WHERE
	bulletin_date = (SELECT DATEADD(DAY, (DATEDIFF(DAY, 6, GETDATE()) / 7) * 7 + 7, 6))
	AND approved_by <> ''
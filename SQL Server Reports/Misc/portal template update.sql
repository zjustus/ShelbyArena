--SELECT * from dbo.port_template -- lists the templates stored in arena

UPDATE dbo.port_portal_page
SET template_id = 39 --the id of the template to update the members responsive sight with
where template_id = 26 --the current template of the website
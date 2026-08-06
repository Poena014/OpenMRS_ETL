use OpenmrsETL
GO 

CREATE TABLE FactCondicionClinica(
	id INT,
	campo1 VARCHAR(50)
)

CREATE INDEX primary_ind ON FactCondicionClinica (id)
GO
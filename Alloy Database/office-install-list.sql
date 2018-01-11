SELECT
		[Soft_Products].[Product_Name]
	  ,[Computers].[Computer_Name]
	  ,[Persons].[Full_Name]
      ,[Detected_Software_Products].[First_Audit]
      ,[Detected_Software_Products].[Last_Audit]
	FROM [ALLOYDB].[dbo].[Detected_Software_Products]
		JOIN [Soft_Products] ON [Soft_Products].[ID]=[Detected_Software_Products].[Soft_Product_ID]
		JOIN [Computers] ON [Computers].[ID]=[Detected_Software_Products].[Object_ID]
		JOIN [Persons] ON [Persons].[ID]=[Computers].[Owner_ID]
	WHERE [Soft_Products].[Product_Name] LIKE '%Microsoft Office Professional%'
	ORDER BY [Soft_Products].[Product_Name] ASC;
USE Agency_DW
GO

-- Which employee creates trips with the highest OTW? 

SELECT distinct
    name_surname,
    AVG(OTW) over (partition by e.employee_ID) as avg_otw,
    count(*) over (partition by e.employee_ID) as count
FROM Employee e
LEFT JOIN TripScheduling t ON e.employee_ID = t.employee_ID
order by avg_otw desc, count desc

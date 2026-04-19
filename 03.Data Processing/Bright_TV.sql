--------------------Bright TV Analayses---------------------------------------------------------------
SELECT
--------------------Performing  Count on USER ID -----------------------------------------------------
   COUNT(DISTINCT UserID0) AS Number_of_Viewers,
   Channel2,

--------------------Date Manipulation and Time Convertion form UTC TO SAST---------------------------
   DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'yyyy-MM-dd HH:mm:ss') AS SAST_Record_Date,
        MONTHNAME(SAST_Record_Date) AS Month_Name,
        DAYNAME(SAST_Record_Date) AS Day_Name,
        CASE 
        WHEN DAYNAME(DATEADD(HOUR, 2, TO_TIMESTAMP(`RecordDate2`))) 
        IN ('Saturday', 'Sunday')  THEN 'Weekend'
        ELSE 'Weekday'
        END AS Day_Classification,

        DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') AS Record_Time,
        CASE
            WHEN  DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') IS NULL ThEN ('Unspecified')
            WHEN  DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN '1.Early Morning'
            WHEN  DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '2.Morning'
            WHEN  DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '3.Afternoon'
            WHEN  DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss') BETWEEN '17:00:00' AND '20:59:59' THEN '4.Evening'
            ELSE 'Night'
      END AS Time_Buckets,
        DATE_FORMAT(DATEADD(HOUR, 2, `Duration 2`),'HH:mm:ss') AS SAST_Duration,

----------------------Handling Categorical data -----------------------------------------
        COALESCE(Gender, 'Unknown') AS Gender,
        COALESCE(Race, 'No Classification') AS Race,
           CASE 
                WHEN Age IS NULL THEN 'Unspecified'
                WHEN Age < 18 THEN 'Under 18'
                WHEN Age BETWEEN 18 AND 35 THEN 'Young'
                WHEN Age BETWEEN 36 AND 60 THEN 'Adults'
                ELSE 'Old'
          END AS Age_Group,
        COALESCE(Province, 'No Classification') AS Province
FROM `workspace`.`default`.`viewership`AS VW
LEFT JOIN  user_profiles  AS UP 
ON VW.UserID0 = UP.UserID
GROUP BY Channel2,
         DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'yyyy-MM-dd HH:mm:ss'),
         MONTHNAME(SAST_Record_Date),
         DAYNAME(SAST_Record_Date),
         DATE_FORMAT(DATEADD(HOUR,2,TO_TIMESTAMP(`RecordDate2`)),'HH:mm:ss'),
         DATE_FORMAT(DATEADD(HOUR, 2, `Duration 2`),'HH:mm:ss'),
         Day_Classification,
         Gender,
         Race,
         Age,
         Province;

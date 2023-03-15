--Player data table 
select * 
from [Portfolio Project].dbo.playerData

--Match data table
select *
from [Portfolio Project]..matchData;

--Map data table
select *
from [Portfolio Project]..mapData;

--Player data ordered by the Average combat score(ACS)
select *
from [Portfolio Project]..playerData
order by mapId,team, acs desc;

-- Sum of ACS of players in all games grouped by the team and stored in teamAsc1 table
select player.name, player.team , SUM(player.acs) as totalAcs
into teamAcs1
from [Portfolio Project]..playerData as player
inner join [Portfolio Project]..mapData as map
on player.mapId=map.id
group by player.name,player.team
order by player.team, totalAcs desc;

select *
from teamAcs1
order by team,totalAcs desc;

--Finding the total sum of ACS of all teams
select team, sum(totalAcs) as totalteamAcs
from teamAcs1
group by team;

--Contribution of players in their total team's ACS
SELECT player.name, player.team, 
       SUM(player.acs) as totalAcs, 
       round(100.0 * SUM(player.acs) / team.totalteamAcs, 2) as percentageOfTeamAcs
INTO Acsweight
FROM [Portfolio Project]..playerData as player
INNER JOIN [Portfolio Project]..mapData as map
ON player.mapId=map.id
INNER JOIN (
    select team, sum(totalAcs) as totalteamAcs
	from teamAcs1
	group by team
) as team
ON player.team = team.team
GROUP BY player.name, player.team, team.totalteamAcs
ORDER BY player.team, totalAcs DESC;
/*
The above results tells us that how well the players are performing with their team
*/

/*
Calculating score of all teams, defined as the sum of difference of players ACS with the bottom player ACS within a team
For example, there are 5 players in a team: P1, P2, P3, P4, P5
They have a sum of ACS throughout the tournament: 70, 50, 40, 30, 10 respectively
so the score for the team = (70-10)+(50-10)+(40-10)+(30-10)
*/
-- Create a temporary table with the query results
SELECT 
  teamAcs2.team, 
  SUM(teamAcs2.totalAcs - teamAcs2.minTotalAcs) AS teamScore
INTO #tempTeamScores
FROM (
  SELECT 
    teamAcs1.team, 
    teamAcs1.totalAcs, 
    MIN(teamAcs1.totalAcs) OVER (PARTITION BY teamAcs1.team) AS minTotalAcs
  FROM teamAcs1
) AS teamAcs2
GROUP BY teamAcs2.team
ORDER BY teamScore DESC;

-- Create a permanent table with the results of the query
CREATE TABLE teamScores (
  team VARCHAR(50),
  teamScore INT
);

INSERT INTO teamScores (team, teamScore)
SELECT team, teamScore
FROM #tempTeamScores;

-- Drop the temporary table
DROP TABLE #tempTeamScores;

-- Finding the relative standard deviation of ACS of players throughout the tournament
select name, round(100 * STDEV(acs)/avg(acs),2) as relativeStd
into acsdev
from [Portfolio Project].dbo.playerData
group by name;
/*
The above result shows consistency of players performance throughout the tournament, 
if the deviation is high the player's performance is not consistent.
*/





 

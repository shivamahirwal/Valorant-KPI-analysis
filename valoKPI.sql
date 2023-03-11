select * 
from [Portfolio Project].dbo.playerData

select *
from [Portfolio Project]..matchData;

select *
from [Portfolio Project]..mapData;

select distinct name, playerId
from [Portfolio Project]..playerData;

select *
from [Portfolio Project]..playerData
order by mapId,team, acs desc;

select name,playerId, team
from [Portfolio Project]..playerData
group by team

select player.name,map.mapName
from [Portfolio Project]..playerData as player
inner join [Portfolio Project]..mapData as map
on player.mapId=map.id


select * 
from [Portfolio Project].dbo.playerData;

create table maxacs_temp as
	select max(acs) over (partition by mapId, team) as maxacs, acs,
	id, playerId into maxacs_temp
	from [Portfolio Project]..playerData; 


select * 
from [Portfolio Project].dbo.playerData;
select * from maxacs_temp;

select playerId, Count(playerId) as Frequency into topfragcount
from maxacs_temp
where maxacs = acs
group by playerId;

select playerId, Count(playerId) as matchFrequency into totalmatchcount
from [Portfolio Project]..playerData
group by playerId;

SELECT (topfragcount.Frequency / totalmatchcount.matchFrequency)  as result, topfragcount.playerId
FROM topfragcount INNER JOIN totalmatchcount
ON topfragcount.playerId = totalmatchcount.playerId;  

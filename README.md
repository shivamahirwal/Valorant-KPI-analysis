# Valorant-KPI-analysis
Estimating KPIs for players in a Valorant(e-sport) tournament

A small portfolio project for enhancing my skill to write SQL queries. In this project, I am trying to estimate the Key-Performance-Indicators(KPIs) of professional Valorant teams and their players using data of a tournament.

First, I scrapped the data from (vlr.gg) website and parsed the HTML data using Beautiful Soup library. I converted the dataframes in CSVs to import them to MS SQL.
I had three tables of data,
- Player data: Name of all players with their performances in all the matches in the tournament
- Map data: Details of all the matches, teams, score, rounds, maps
- Match data: Date and teams which played and their score

Using this data, three KPIs were estimated:
- Weighted performance of player: Contribution of each player to the total ACS(average combat score) in the tournament
- Team Score: Sum of difference ACS and minimum ACS within a team
- Player's consistency: Relative standard deviation of players 

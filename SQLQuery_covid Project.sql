select *
From Project1..CovidDeaths
order by 3, 4


--Select *
--FRom Project1..CovidVaccinations
--order by 3, 4


--select data that will be used in this project 


Select Location, date,total_cases, new_cases,total_deaths,population
From Project1..CovidDeaths
order by 1,2

-- Searching for Toatal cases Vs Total Deaths

Select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 As death_Percentage 
From Project1..CovidDeaths
order by 1,2

-- Searching for maximum death percent by country 

Select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 As death_Percentage 
From Project1..CovidDeaths
where  location Like '%India%'
order by 1,2

-- searching for tatal cases vs population 
-- shows what percentage of population got covid 


Select Location, date,Population, total_cases,(total_cases/Population)*100 As death_Percentage 
From Project1..CovidDeaths
where  location Like '%India%'
order by 1,2


-- searching for countries with Highest Infection Rate poplulation 

Select Location,Population, max(total_cases) as HighestInfectioncount ,max(total_cases/Population)*100 As Percent_populationInfected 
From Project1..CovidDeaths
Group By Location,Population
order by Percent_populationInfected DESC




-- searching for countries with Highest deathcount per  poplulation

Select Location,Population, max (cast(total_deaths as Integer)) as Totaldeathcount ,max(total_deaths/Population)*100 As Percent_populationdeath
From Project1..CovidDeaths
where Continent is not null
Group By Location,Population
order by Totaldeathcount DESC

-- grouping by continent ( data is not added properly ,thtas why location is instead of continnenent , ideally it should have cotinenent is not null )

Select Location, max (cast(total_deaths as Integer)) as Totaldeathcount
From Project1..CovidDeaths
where Continent is null
Group By Location
order by Totaldeathcount DESC


-- global figure

Select sum(new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum (cast(new_deaths as int ))/sum(New_cases)*100 As death_Percentage 
From Project1..CovidDeaths
--where  location Like '%India%'
where continent is not null
--group by date 
order by 1,2

-- just checking again vaccination table

select *
from Project1..CovidVaccinations

-- looking for Total population vs vaccination

select cd.continent, cd.location, cd.date,cd.population,cv.new_vaccinations
From Project1..CovidDeaths cd
join  Project1..CovidVaccinations cv
  on cd.location = cv.location 
  and cd.date = cv.date
  where cd.continent is not null
  order by 2,3
as
  (
  sel
-- using windows funtions 

select cd.continent, cd.location, cd.date,cd.population,cv.new_vaccinations
, SUM (convert (int ,cv.new_vaccinations)) OVER (Partition by  cd.location order by cd.location, cd.date)
From Project1..CovidDeaths cd
join  Project1..CovidVaccinations cv
  on cd.location = cv.location 
  and cd.date = cv.date
  where cd.continent is not null
  order by 2,3

  --using CTE 
  with popVSvacc (continent, location,date, population, new_vaccinations,RollingpeopleVaccinated)
  as
  (
  select cd.continent, cd.location, cd.date,cd.population,cv.new_vaccinations
, SUM (convert (int ,cv.new_vaccinations)) OVER (Partition by  cd.location order by cd.location, cd.date) as RollingpeopleVaccinated
From Project1..CovidDeaths cd
join  Project1..CovidVaccinations cv
  on cd.location = cv.location 
  and cd.date = cv.date
  where cd.continent is not null
  -- order by 5,6
)
select*, (RollingpeopleVaccinated/population)*100
From popVSvacc
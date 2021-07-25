select * from PortfolioProject..['Covid Deaths$']
where continent is not null
order by date

select * from PortfolioProject..['Covid Vaccination$']
order by location, date

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..['Covid Deaths$']
order by location,date


-- Looking at Total Cases vs Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..['Covid Deaths$']
where location like '%india%'
order by location,date


--Looking at total cases vs population
--percentatage of population got covid
select location,date,population,total_cases, (total_cases/population)*100 as PercentOfPopulation
from PortfolioProject..['Covid Deaths$']
where location like '%india%'
order by location,date


--Looking at countries a=with highest infection rate

select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentOfPopulationInfected
from PortfolioProject..['Covid Deaths$']
group by location, population
order by 4 desc
--where location like '%india%'


-- Showing the countries with highest deatcount per population

select location,max(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..['Covid Deaths$']
where continent is not null
group by location

order by TotalDeathsCount desc


---LET'S breaks things down by continent


select location,max(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..['Covid Deaths$']
where continent is null
group by location
order by TotalDeathsCount desc


--Showing the continents with highest death cnt per poplulation


select continent,max(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..['Covid Deaths$']
where continent is not null
group by continent
order by TotalDeathsCount desc


--- BREAKING TO GLOABAL NUMBERS


select date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..['Covid Deaths$']
--where location like '%india%'
where continent is not null

order by location,date


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as totalDeath, sum(cast(new_deaths as int))*100/sum(new_cases) as death_percentage --total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..['Covid Deaths$']
--where location like '%india%'
where continent is not null
--group by date
order by 1,2


-- LOOKING AT TO POULATION VS VACCINATION

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated,
from PortfolioProject..['Covid Deaths$'] dea
join
PortfolioProject..['Covid Vaccination$'] vac
on dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null
order by 2,3


--use cte

With PopvsVac (Continent, Location, Date, Population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from PortfolioProject..['Covid Deaths$'] dea
join
PortfolioProject..['Covid Vaccination$'] vac
on dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccinated/Population)*100 from PopvsVac




--CREATING VIEW TO STORE DATA FOR VISUALIZATION

CREATE VIEW PercentPopulationVaccinatedd as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from PortfolioProject..['Covid Deaths$'] dea
join
PortfolioProject..['Covid Vaccination$'] vac
on dea.location=vac.location
and
dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinatedd
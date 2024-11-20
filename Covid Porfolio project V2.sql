select * from PortfolioProject..Coviddeaths
order by 3,4

--select * from PortfolioProject..CovidVaccinations
--order by 3,4

 select  location,date,total_cases,new_cases,total_deaths,population 
 from PortfolioProject..Coviddeaths
 order by 1,2

 -- looking at total cases vs  total deaths '

 select  location,date,total_cases,total_deaths, 
        (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS deathpercentage
from PortfolioProject..Coviddeaths
where location Like '%states%'
 order by 1,2



 --looking at total cases vs populations 
 -- shows what percentage of population got covid 

 select  location,date,total_cases,population, 
        (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS deathpercentage
from PortfolioProject..Coviddeaths
where location Like '%states%'
 order by 1,2



 --- looking at countries with highest infection rate compared to population 


 --Select location,population, MAX(total_cases) as Highestinfectioncount , MAX(cast(total_cases  as float) /cast(Population as float))*100 as Percentageinfected
 
 --from Coviddeaths
 --group by location,population
 --order by Percentageinfected 


 --showing countries with highest deadth count per population 

Select continent, MAX(cast(total_deaths as int)) as TotalDeadth
from PortfolioProject..Coviddeaths
where continent is not null
Group by continent
Order by TotalDeadth desc




Select location, MAX(cast(total_deaths as int)) as TotalDeadth
from PortfolioProject..Coviddeaths
where continent is  null
Group by location
Order by TotalDeadth desc



Select continent, MAX(cast(total_deaths as int)) as TotalDeadth
from PortfolioProject..Coviddeaths
where continent is not null
Group by continent
Order by TotalDeadth desc


--showing continents with the highest deadth count per population 

Select continent, MAX(cast(total_deaths as int)) as TotalDeadthcount
from PortfolioProject..Coviddeaths
where continent is not null
Group by continent
Order by TotalDeadthcount desc




--break in global number 





 select date,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeadths, sum(cast(new_deaths as Float))/SUM(CAST(new_cases AS FLOAT))*100 as deadthpercent   --        (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS deathpercentage
from PortfolioProject..Coviddeaths
where continent is not null
group by date
 order by 1,2


 
 select sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeadths, sum(cast(new_deaths as Float))/SUM(CAST(new_cases AS FLOAT))*100 as deadthpercent   --        (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS deathpercentage
from PortfolioProject..Coviddeaths
where continent is not null
 order by 1,2
 




select * 
from PortfolioProject..Coviddeaths dea

join  PortfolioProject..CovidVaccinations vac

  on dea.location = vac.location
  and dea.date = vac.date

   ---looking total population vs vaccination 


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as rollingpeoplevacinated
from PortfolioProject..Coviddeaths dea

join  PortfolioProject..CovidVaccinations vac

  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3



  --use CTE

  with PopvsVac(Continent, Location, Date, Population,New_Vaccinations, rollingpeoplevacinated)

  as

 ( 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) 
	 as rollingpeoplevacinated --(CAST(rollingpeoplevacinated as int) / population ) *100
from PortfolioProject..Coviddeaths dea

join  PortfolioProject..CovidVaccinations vac

  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  )

select * ,(cast(rollingpeoplevacinated as float)/Population)*100
from PopvsVac



--temp table 

drop Table if exists  #PercentPopulationVaccinated 
create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_Vaccinations numeric,
rollingpeoplevacinated numeric
)
insert into #PercentPopulationVaccinated 


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) 
	 as rollingpeoplevacinated --(CAST(rollingpeoplevacinated as int) / population ) *100
from PortfolioProject..Coviddeaths dea

join  PortfolioProject..CovidVaccinations vac

  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  

select * ,(cast(rollingpeoplevacinated as float)/Population)*100
from #PercentPopulationVaccinated 





--creating view to store data for later visualization 


Create VIEW #PercentPopulationVaccinated AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) 
	 as rollingpeoplevacinated --(CAST(rollingpeoplevacinated as int) / population ) *100
from PortfolioProject..Coviddeaths dea

join  PortfolioProject..CovidVaccinations vac

  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  --order by 2,3
  

  select * from #PercentPopulationVaccinated






SELECT 
    location,
    date,
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths,
    (CAST(SUM(total_deaths) AS FLOAT) / SUM(total_cases)) * 100 AS deathpercentage
FROM PortfolioProject..Coviddeaths
GROUP BY location, date
ORDER BY location, date;

({
	getApiData : function(component) {
		var action = component.get('c.getCovidData');
        
        action.setCallback(
            this, function(response){
                component.set("v.spinner", false);
                event="aura:doneWaiting";
                var state= response.getState();
                console.log(response.getError());
                
                if(state === 'SUCCESS'|| state ==='DRAFT'){
                    alert('SUCCESS');
                    
                	var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    component.set('v.newConfirmed',result.allstats.NewConfirmed);
                    component.set('v.confirmed',result.allstats.TotalConfirmed);
                    component.set('v.recovered',result.allstats.TotalRecovered);
                    component.set('v.deaths',result.allstats.TotalDeaths);
                    
                    var dataArray =[];
                    for(var i=0;i<result.countries.length;i++){
                        var fetchData = {
                            id:i,
                            country:result.countries[i].Country,
                            newConfirmed:result.countries[i].NewConfirmed,
                            totalConfirmed:result.countries[i].TotalConfirmed,
                            newRecovered:result.countries[i].NewRecovered,
                            totalRecovered:result.countries[i].TotalRecovered,
                            newDeaths:result.countries[i].NewDeaths,
                            totalDeaths:result.countries[i].TotalDeaths
                        }
                        
                        dataArray.push(fetchData);
                    }
                    component.set('v.data',dataArray);
                    
                }else if(state === 'ERROR'){
                    alert('ERROR');
                }else if(state === 'INCOMPLETE'){
                    alert('INCOMPLETE');
                }
            },'ALL');
        
        $A.enqueueAction(action);
	}
})
({
    afterScriptLoad : function(component, event, helper) {
        var backgroundColors = ["#63A0DE","#23335B","#A3DBD8","#65A29E", "#DBCD82", "#D1A124", "#A44738"];
        var action = component.get("c.getChartData");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var chartData = response.getReturnValue();
                if(!$A.util.isEmpty(chartData)) {
                    var eventNames = chartData.eventNames;
                    var statuses = chartData.statuses;
                    var counts = chartData.counts;
                    var canvas = document.getElementById("graphCanvas");
                    
                    var chartDatasets = [];
                    statuses.forEach(function(status) {
                        chartDatasets.push({
                            label: status,
                            backgroundColor: backgroundColors[statuses.indexOf(status)],
                            data: counts[statuses.indexOf(status)]
                        });
                    });
                    
                    var myChart = new Chart(canvas, {
                        type: 'bar',
                        data: {
                            labels: eventNames,
                            datasets: chartDatasets
                        },
                        options: {
                            maintainAspectRatio: false,
                            title: {
                                display: true,
                                position: "top",
                                text: "Future Events with Registration Statuses",
                                fontSize: 18
                            },
                            legend: {
                                display: true,
                                position: "right",
                                labels: {
                                    fontColor: "#333",
                                    fontSize: 12
                                },
                            },
                            scales: {
                                xAxes: [{
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Internal Event Name',
                                        fontSize: 14
                                    },
                                    stacked: true
                                }],
                                yAxes: [{
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Record Count',
                                        fontSize: 14
                                    },
                                    stacked: true
                                }]
                            }
                        }
                    });
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})
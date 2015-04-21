<%-- 
    Document   : femaleusersbyEthnicityandRace
    Created on : Mar 10, 2015, 9:25:17 PM
    Author     : chadmccue
--%>




<div id="container" style="min-width: 310px; height: 500px; max-width: 700px; margin: 0 auto"></div>


<script>
    
    require(['./main'], function () {
        require(['jquery', 'highcharts', 'exporting'], function($) {
            
            $(function () {
                $('#container').highcharts({
                    chart: {
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: 'Unduplicated Number of Family Planning Users by Income Level'
                    },
                    tooltip: {
                        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                                style: {
                                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                }
                            }
                        }
                    },
                    series: [{
                        type: 'pie',
                        name: 'Browser share',
                        data: [
                            ['100% and below', 5022],
                            ['101% - 150%', 6035],
                            {
                                name: '151% - 200%',
                                y: 1208,
                                sliced: true,
                                selected: true
                            },
                            ['201% - 250%', 476],
                            ['Over 250%', 202],
                            ['Unknown / not reported',131]
                        ]
                    }],
                    credits: {
                    enabled: false
                    }
                });
            });

        });
    });
</script>

<%-- 
    Document   : femaleusersbyEthnicityandRace
    Created on : Mar 10, 2015, 9:25:17 PM
    Author     : chadmccue
--%>




<div id="container" style="min-width: 310px; height: 550px;"></div>



<script>
    
    require(['./main'], function () {
        require(['jquery', 'highcharts', 'exporting'], function($) {
            
            $(function () {
                $('#container').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: 'Unduplicated Number of Female Family Planning Users by Ethnicity and Race'
                    },
                    xAxis: {
                        categories: [
                            'White',
                            'Black',
                            'AM Indian / Alaskan Native',
                            'Asian',
                            'Native Hawaiian/Other Pacific Islander',
                            'More than One Race',
                            'Not Reported',
                        ],
                        crosshair: true
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: 'Total Women'
                        }
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:20px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                            '<td style="padding:0"><b>{point.y}</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    credits: {
                    enabled: false
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series: [{
                        name: 'Hispanic or Latino',
                        data: [188, 88, 1, 1, 5, 130, 0]

                    }, {
                        name: 'Not Hispanic or Latino',
                        data: [294, 648, 42, 151, 9, 68, 14]

                    }, {
                        name: 'Unknown/Not Reported',
                        data: [70, 0, 0, 0, 0, 1, 4]

                    }]
                });
            });

        });
    });
</script>

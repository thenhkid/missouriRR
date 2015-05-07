<%-- 
    Document   : activityLogs
    Created on : Apr 21, 2015, 10:10:28 AM
    Author     : chadmccue
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="main clearfix" role="main">
    <div class="col-md-12">
        <ul class="breadcrumb" style="background-color: #ffffff;">
            <li><a href="<c:url value="/districts" />">${selCountyName}</a> <span class="divider"></span></li>
            <li><a href="javascript:void('0');">${selDistrictName}</a> <span class="divider"></span></li>
             <li><a href="javascript:void('0');" id="surveyName"></a> <span class="divider"></span></li>
            <li class="active">Activity Logs</li>
        </ul>
        <div class="clearfix">
            <div class="pull-right tableTools-container" style="margin-bottom: 8px;">
                <div class="btn-group btn-overlap">
                    <a id="createNewEntry" class="DTTT_button btn btn-white btn-primary btn-bold" tabindex="0" aria-controls="dynamic-table">
                    <span>
                        <i class="fa fa-plus bigger-110 red"></i>  New Entry
                    </span>
                    <div style="position: absolute; left: 0px; top: 0px; width: 39px; height: 35px; z-index: 99;" title="" data-original-title=""></div>
                    </a>

                </div>
           </div>  
        </div>
        <section class="panel panel-default">
           <div class="panel-body">
                <div class="form-container scrollable" id="activityLogList"></div>
            </div>
        </section>
    </div>
</div>
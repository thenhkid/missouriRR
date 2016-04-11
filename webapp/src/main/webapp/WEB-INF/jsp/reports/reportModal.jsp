<%-- 
    Document   : newEventModal
    Created on : Jun 2, 2015, 4:33:33 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="page-content">
    <form:form id="reportForm" modelAttribute="reportDetails" role="form" class="form" method="post">
        <input type="hidden" name="selectedSites" id="selectedSites" />
        <form:hidden path="uniqueId" id="uniqueId" />
        <form:hidden path="fileTypeId" />

        <c:if test="${noresults}"><div class="alert alert-danger noResults">No results were found based on your date range selected.</div></c:if>

        <div class="row" id="level1Entity">
           <div class="form-group">
                <label class="control-label" for="exportType">${level1Name}</label>
                <select multiple="" class="form-control half level1Entity">
                     <option value="">- Choose -</option>
                     <c:forEach items="${level1Items}" var="level1Item">
                         <option value="${level1Item.id}" selected>${level1Item.name}</option>
                     </c:forEach>
                 </select> 
                <br />
               <button type="button" class="btn btn-mini btn-primary findlevel2Entity">
                    <i class="ace-icon fa fa-search bigger-120 white"></i>
                    Find ${level2Name}
                </button>
            </div>
        </div>
                
        <div class="row" style="display:none" id="level2Entity">
           <div class="form-group">
                <label class="control-label" for="exportType">${level2Name}</label>
                <select multiple="" class="form-control half level2Entity" rel="${entitylevel2}">
                    <option value="">- Choose a ${level2Name} -</option>
                </select>
                <br />
                <button type="button" class="btn btn-mini btn-primary findlevel3Entity">
                    <i class="ace-icon fa fa-search bigger-120 white"></i>
                    Find ${level3Name}
                </button>
            </div>
        </div>
                
        <div class="row" style="display:none" id="level3Entity">
           <div class="form-group">
                <label class="control-label" for="exportType">${level3Name}</label>
                <select multiple="multiple" class="form-control half level3Entity" rel="${entitylevel3}">
                    <option value="">- Choose a ${level3Name} -</option>
                </select> 
                <span class="label label-danger label-white middle level3Error" style="display:none">
                    <i class="ace-icon fa fa-exclamation-triangle bigger-120"></i>
                    Selecting ${level3Name} is required to created a report.
                </span>

            </div>
        </div>


        <div class="row" id="reportDetailsRow" style="display:none">
            <c:if test="${showDateRange == true}">
                <div class="form-group">
                    <div class="row clearfix">
                        <div id="reportStartDateDiv" class="col-md-6">
                            <label class="control-label" for="eventDate">Session Search Start Date</label>
                            <fmt:formatDate value="${reportDetails.startDate}" var="dateStartString" pattern="MM/dd/yyyy" />
                            <form:input path="startDate" class="form-control reportStartDate" placeholder="Start Date" value="${dateStartString}" />
                            <div id="errorMsg_reportStartDate" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                        </div>
                        <div id="reportEndDateDiv"  class="col-md-6">
                            <label class="control-label" for="eventDate">Session Search End Date</label>
                            <fmt:formatDate value="${reportDetails.endDate}" var="dateEndString" pattern="MM/dd/yyyy" />
                            <form:input path="endDate" class="form-control reportEndDate" placeholder="End Date"  value="${dateEndString}"  />
                            <div id="errorMsg_reportEndDate" style="display:none;" class="help-block col-xs-12 col-sm-reset inline"></div> 
                        </div>
                    </div>
                </div>
            </c:if>
            <div class="form-group">
                <div class="exportProgress" style="display:none;">
                    <span>Report Progress:</span>
                    <div class="progress pos-rel" data-percent="0%"><div class="progress-bar" style="width:0%"></div></div>
                </div>

                <button type="button" class="btn btn-mini btn-primary createParticipantReport">
                    <i class="ace-icon fa fa-download bigger-120 white"></i>
                    Create Report
                </button>
            </div>
        </div>

    </form:form>
</div>
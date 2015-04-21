<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-default actions-nav" role="navigation">
    <div class="contain">
        <div class="navbar-header">
            <h1 class="section-title navbar-brand">
                <c:choose>
                   <c:when test="${param['page'] == 'list'}">
                        <a href="javascript:void(0);" title="Client List" class="unstyled-link">Clients</a>
                    </c:when>
                    <c:when test="${param['page'] == 'details'}">
                        <a href="javascript:void(0);" title="Client Details" class="unstyled-link">Client Details</a>
                    </c:when>  
                    <c:when test="${param['page'] == 'engagement'}">
                        <a href="javascript:void(0);" title="Client Engagements" class="unstyled-link">Client Engagements</a>
                    </c:when> 
                    <c:when test="${param['page'] == 'engagementDetails'}">
                        <a href="javascript:void(0);" title="Engagement Details" class="unstyled-link">Engagement Details</a>
                    </c:when> 
                    <c:when test="${param['page'] == 'surveys'}">
                        <a href="javascript:void(0);" title="Client Surveys" class="unstyled-link">Client Surveys</a>
                    </c:when>    
                </c:choose>
            </h1>
        </div>
        <ul class="nav navbar-nav navbar-right navbar-actions" role="menu">
           <c:choose>
               <c:when test="${param['page'] == 'list'}">
                   <c:if test="${not empty entryMethods}">
                       <c:forEach items="${entryMethods}" var="entryMethod">
                           <c:choose>
                               <%-- Engagement Patient Entry Form --%>
                               <c:when test="${entryMethod.useEngagementForm == true}">
                                   <li role="menuitem"><a href="javascript:void(0);"  id="newPatientViaEngagement" title="${entryMethod.btnValue}" role="button"><span class="glyphicon glyphicon-plus icon-stacked"></span> ${entryMethod.btnValue} </a></li>
                               </c:when>
                                   
                               <%-- Survey Patient Entry Form --%>
                               <c:when test="${entryMethod.surveyId > 0}">
                                   <li role="menuitem"><a href="javascript:void(0);" id="saveDetails" title="${entryMethod.btnValue}" role="button"><span class="glyphicon glyphicon-plus icon-stacked"></span> ${entryMethod.btnValue} </a></li>
                               </c:when>
                                   
                               <%-- Generic Patient Entry Form --%>
                               <c:otherwise>
                                   <li role="menuitem"><a href="javascript:void(0);" id="saveDetails" title="${entryMethod.btnValue}" role="button"><span class="glyphicon glyphicon-plus icon-stacked"></span> ${entryMethod.btnValue} </a></li>
                               </c:otherwise>
                           </c:choose>
                       </c:forEach>
                   </c:if>
               </c:when>
                <c:when test="${param['page'] == 'details' || param['page'] == 'engagementDetails'}">
                    <li role="menuitem"><a href="javascript:void(0);" id="saveDetails" title="Save Form" role="button"><span class="glyphicon glyphicon-ok icon-stacked"></span> Save </a></li>
                    <li role="menuitem"><a href="javascript:void(0);" id="saveCloseDetails" title="Save &amp; Close" role="button"><span class="glyphicon glyphicon-floppy-disk icon-stacked"></span> Save &amp; Close</a></li>
                    <c:choose>
                        <c:when test="${param['page'] == 'details'}">
                            <li role="menuitem"><a href="/clients" title="Save &amp; Close" role="button"><span class="glyphicon glyphicon-ban-circle icon-stacked"></span> Cancel</a></li>
                       </c:when>
                    <c:when test="${param['page'] == 'engagementDetails'}">
                            <li role="menuitem"><a href="../engagements?i=${iparam}&v=${vparam}" title="Save &amp; Close" role="button"><span class="glyphicon glyphicon-ban-circle icon-stacked"></span> Cancel</a></li>
                       </c:when>
                    </c:choose>
                </c:when>
                <c:when test="${param['page'] == 'engagement'}">
                    <li role="menuitem"><a href="engagements/details?i=${iparam}&v=${vparam}" id="newEngagement" title="New Engagement" role="button"><span class="glyphicon glyphicon-plus icon-stacked"></span> New Engagement </a></li>
                </c:when> 
                <c:when test="${param['page'] == 'surveys'}">
                    <li role="menuitem">
                        <a style="text-decoration:none;" href="#surveyModal" data-toggle="modal" title="New Survey" class="newSurvey"><span class="glyphicon glyphicon-plus-sign icon-stacked"></span> New Survey</a>
                    </li>
                </c:when>
          </c:choose>
        </ul>
    </div>
</nav>
<!-- Hierarchy Item Edit/Create modal -->
<div class="modal fade" id="surveyModal" role="dialog" tabindex="-1" aria-labeledby="Modified By" aria-hidden="true" aria-describedby="Modified By"></div>

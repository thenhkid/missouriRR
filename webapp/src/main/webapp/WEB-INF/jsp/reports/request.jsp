<%-- 
    Document   : survey
    Created on : Mar 5, 2015, 1:10:08 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="row">
    <div class="col-xs-12">
<div class="row">
     <div class="col-sm-12">
    Please select reporting criteria:
    <hr/>
     </div>
</div>
        <form class="form-horizontal" id="newReport" method="post" action="/reports" role="form">
            <%-- row for start /end dates --%>
            <div class="row">
                <div class="col-sm-6">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Start Date</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                 <div class="input-group">
                                        <input class="form-control  date-picker  required Date" id="id-date-picker-1" type="text" name="startDate" data-date-format="mm/dd/yyyy" value="" />
                                          <span class="input-group-addon">
                                        <i class="fa fa-calendar bigger-110"></i>
                                         </span>
                                  </div>       
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->

                <div class="col-sm-6">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">End Date</h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div class="input-group">
                                        <input class="form-control  date-picker  required Date" id="id-date-picker-1" type="text" name="endDate" data-date-format="mm/dd/yyyy" value="" />
                                          <span class="input-group-addon">
                                        <i class="fa fa-calendar bigger-110"></i>
                                         </span>
                                  </div> 
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            <%-- end of row for start /end dates --%>
            
            <%-- start of counties, this should be closed & selected if user only has one county --%>
           <c:if test="${fn:length(entity1List) > 1}">
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                        <%-- hard coded because plural is not just adding (s)  --%>
                            <h4 class="widget-title">Please select county / counties </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up inactive"></i>
                                </a>
                            </div>
                        </div>
						
                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select name="entity1Ids" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                            <c:forEach items="${entity1List}" var="county">
                                                    <option value="${county.id}">${county.name}</option>
                                            </c:forEach>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
            </c:if>
            <c:if test="${fn:length(entity1List) == 1}">
                        	<input type="hidden" name="entit1Ids" value="${entity1List[0].id}"/>
            </c:if>
            <jsp:include page="optionList.jsp">
    				<jsp:param name="entity2Ids" value="${entity2List}" />
			</jsp:include>
           
            
            <%-- start of surveys --%>
            <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Surveys</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        <option>Resources Leveraged/Grant Proposals</option>
                                            <option>Resources / Tools Used</option>
                                            <option>Meetings</option>
                                            <option>Media/Promotions</option>
                                            <option>Events/Programs</option>
                                            <option>Successes/Challenges/Other Info</option>
                                            <option>Practice, Policy,  Environmental Change</option>
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
                <%-- end of surveys --%>
                
                <%-- start of report types --%>
                <div class="row">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Report Type</h4>

                            <span class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </span>
                        </div>
						<%--- get distinct report type ---%>
                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select name="entityIds" class="chosen-select form-control" <c:if test="${disabled == true}">disabled</c:if> id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                        	<option>Summary Count Report</option>
                                            <option>Detail Report</option>
                                            
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                </div><!-- row -->
               <%-- end of report types --%>
               <%-- buttons --%>
                <div class="wizard-actions">
               <button class="btn btn-success btn-next nextPage" data-last="Finish">
                                                        Request Report
                                                        
                                                    </button>
                </div>
        </form>
    </div>
</div>


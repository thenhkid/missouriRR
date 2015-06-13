<%-- 
    Document   : faq
    Created on : May 18, 2015, 10:34:19 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="page-header">
    <h1>
        FAQ
        <small>
            <i class="ace-icon fa fa-angle-double-right"></i>
            frequently asked questions using tabs and accordions
        </small>
    </h1>
</div><!-- /.page-header -->

<div class="row">
    <div id="resultBox" class="hidden">
   </div>
   <div class="col-xs-12">
        <!-- PAGE CONTENT BEGINS -->
        <div class="tabbable">
            <ul class="nav nav-tabs padding-18 tab-size-bigger" id="myTab">
                
                <%-- start looping here --%>
                <c:forEach var="category" items="${categoryList}">
                    <li <c:if test="${category.displayPos==1}">class="active"</c:if>>
                        <a data-toggle="tab" href="#faq-tab-${category.id}">
                            <i class="blue ace-icon fa fa-question-circle bigger-120"></i>
                            ${category.categoryName}
                        </a>
                    </li>
                </c:forEach>
                <%-- settings --%>
                <li class="dropdown">
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                        <i class="purple ace-icon fa fa-magic bigger-120"></i>

                        Settings
                        <i class="ace-icon fa fa-caret-down"></i>
                    </a>

                    <ul class="dropdown-menu dropdown-lighter dropdown-125">
                        <li>
                            <a data-toggle="tab" href="#faq-tab-s" id="addCategory">Add Category</a>
                        </li>

                        <li>
                            <a data-toggle="tab" href="#faq-tab-s" id="addQuestion"> Add Question </a>
                        </li>
                        
                        <li>
                            <a data-toggle="tab" href="#faq-tab-s" id="addDocument"> Add Document</a>
                        </li>
                    </ul>
                </li><!-- /.dropdown -->
                <%-- /settings --%>
            </ul>
                
            <%-- here we query the questions for each category --%>
            <div class="tab-content no-border padding-24">
                <c:forEach var="category" items="${categoryList}">
                    <div id="faq-tab-${category.id}" class="tab-pane fade in <c:if test="${category.displayPos==1}">active</c:if>">
                        <h4 class="blue">
                            <i class="ace-icon fa fa-check bigger-110"></i>
                            ${category.categoryName} 
                            <a href="#" class="btn-sm btn-app btn-primary editCategory" rel="${category.id}">
                                            <i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                            Edit
                                        </a>
                                        <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
                                        </sec:authorize>
                        </h4>

                    <div class="space-8"></div>

                    <div id="faq-list-${category.id}" class="panel-group accordion-style1 accordion-style2">
                        <c:forEach var="question" items="${category.faqQuestions}">
                            <%-- question --%>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="#faq-${category.id}-${question.id}" data-parent="#faq-list-${category.id}" data-toggle="collapse" class="accordion-toggle collapsed">
                                    <i class="ace-icon fa fa-chevron-left pull-right" data-icon-hide="ace-icon fa fa-chevron-down" data-icon-show="ace-icon fa fa-chevron-left"></i>
                                    <i class="ace-icon fa fa-user bigger-130"></i>
                                    &nbsp; ${question.question} 
                                    <%-- code to restrict who sees this -- need to move between sec tag --%>
                                    
                                        <a href="#" class="btn-xs btn-app btn-success no-radius editQuestion" rel="${question.id}">
					<i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                            Edit
                                        </a>
                                    <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
                                    </sec:authorize>
                                </a>
                            </div>

                            <div class="panel-collapse collapse" id="faq-${category.id}-${question.id}">
                                <div class="panel-body">
                                    ${question.answer}
                                    <%-- loop documents here --%>
                                    <c:forEach var="document" items="${question.faqQuestionDocuments}">
                                        <br/>
                                          <c:choose>
                                              <c:when test="${!fn:contains(document.documentLocation, 'http')}">
                                                  <c:set var="location" value="faq/viewDoc.jsp?i=${document.id}"/> 
                                              </c:when>
                                              <c:otherwise>
                                                  <c:set var="location" value="${document.documentLocation}"/>
                                              </c:otherwise>
                                          </c:choose>
                                          <a href="${location}" target=_blank">${document.documentTitle}</a>
                                          <a href="#" class="btn-xs btn-app btn-yellow no-radius editDocument" rel="${document.id}">
                                            <i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                            Edit
                                        </a>
                                        <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
                                        </sec:authorize>
                                    </c:forEach>
                                </div>
                            </div>  
                        </div>
                        </c:forEach>      
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>

        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->
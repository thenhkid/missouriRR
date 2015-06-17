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
                <c:forEach var="category" items="${categoryList}" varStatus="loop">
                    <li class="center <c:if test="${empty activeCat && loop.index == 0}">active</c:if><c:if test="${category.id == activeCat}">active</c:if>">
                        <a data-toggle="tab" href="#faq-tab-${category.id}">
                            <span class="badge badge-info">${fn:substring(category.categoryName, 0, 1)}</span><br />
                            ${category.categoryName}
                        </a>
                    </li>
                </c:forEach>
                    
                <%-- settings --%>
                <sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_PROGRAMADMIN', 'ROLE_SYSTEMADMIN')">
                <li class="dropdown center">
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                        <span class="badge badge-info">S</span><br />
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
                    </ul>
                </li><!-- /.dropdown -->
                </sec:authorize>
                <%-- /settings --%>
            </ul>
                
            <%-- here we query the questions for each category --%>
            <div class="tab-content no-border padding-24">
                <c:forEach var="category" items="${categoryList}" varStatus="loop">
                    <div id="faq-tab-${category.id}" class="tab-pane fade in <c:if test="${empty activeCat && loop.index == 0}">active</c:if><c:if test="${category.id == activeCat}">active</c:if>">
                        <h4 class="blue">
                            <i class="ace-icon fa fa-check bigger-110"></i>
                            ${category.categoryName}
                            <sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_PROGRAMADMIN', 'ROLE_SYSTEMADMIN')">
                            <a href="#" class="btn-sm btn-app btn-primary editCategory" rel="${category.id}">
                                            <i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                            Edit
                                        </a>
                             </sec:authorize>
                        </h4>

                    <div class="space-8"></div>

                    <div id="faq-list-${category.id}" class="panel-group accordion-style1 accordion-style2">
                        <c:forEach var="question" items="${category.faqQuestions}">
                            <%-- question --%>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="#faq-${category.id}-${question.id}" data-parent="#faq-list-${category.id}" data-toggle="collapse" class="accordion-toggle collapsed">
                                    <i class="ace-icon fa <c:if test='${question.id != activeQuestion}'>fa-chevron-left</c:if><c:if test='${question.id == activeQuestion}'>fa-chevron-down</c:if> pull-right" data-icon-hide="ace-icon fa fa-chevron-down" data-icon-show="ace-icon fa <c:if test='${question.id == activeQuestion}'>in</c:if> fa-chevron-left"></i>
                                    <i class='ace-icon fa fa-user bigger-130'></i>
                                    &nbsp; ${question.question}
                                    <%-- code to restrict who sees this -- need to move between sec tag --%>
                                    <sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_PROGRAMADMIN', 'ROLE_SYSTEMADMIN')">
                                        <a href="#" class="btn-xs btn-app btn-success no-radius editQuestion" rel="${question.id}">
					<i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                            Edit
                                        </a>
                                        <%--ROLE_PROGRAMADMIN--%>
                                    </sec:authorize>
                                    
                                </a>
                            </div>

                                        <div class="panel-collapse collapse <c:if test='${question.id == activeQuestion}'>in</c:if>" id="faq-${category.id}-${question.id}">
                                <div class="panel-body">
                                    ${question.answer}
                                    <%-- loop documents here --%>
                                    <c:forEach var="document" items="${question.faqQuestionDocuments}">
                                        <br/>
                                          
                                          <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.documentTitle}&foldername=faqUploadedFiles"/>">
                                             ${document.documentTitle}
                                          </a>
                                          
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
            <%-- need to remove user role --%>
            <sec:authorize access="hasAnyRole('ROLE_USER', 'ROLE_PROGRAMADMIN', 'ROLE_SYSTEMADMIN')">
                <form action="" method="post" id="deleteQuestion">
                    <input type="hidden" name="questionId" id="deleteQuestionId"/>
                </form>
                <form action="" method="post" id="deleteCategory">
                    <input type="hidden" name="categoryId" id="deleteCategoryId"/>
                </form>
            </sec:authorize>
        <!-- PAGE CONTENT ENDS -->
    </div><!-- /.col -->
</div><!-- /.row -->
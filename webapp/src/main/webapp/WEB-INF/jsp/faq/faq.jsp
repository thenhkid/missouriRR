<%-- 
    Document   : faq
    Created on : May 18, 2015, 10:34:19 AM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

 <c:if test="${not empty error}" >
    <div class="alert alert-danger" role="alert">
        The selected file was not found.
    </div>
</c:if>


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
                        <a data-toggle="tab" href="#faq-tab-${category.id}" class="categoryNav" rel="${category.id}">
                            <span class="badge badge-info ">${fn:substring(category.categoryName, 0, 1)}</span><br />
                            ${category.categoryName}
                        </a>
                    </li>
                </c:forEach>

                <%-- settings --%>
                <c:if test="${allowCreate == true}">
                    <li class="dropdown center">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <span class="badge badge-info">S</span><br />
                            Settings
                            <i class="ace-icon fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-lighter dropdown-125">
                            <%--<c:if test="${sessionScope.userDetails.roleId == 2}">
                                <li>
                                    <a data-toggle="tab" href="#faq-tab-s" id="addCategory">Add Category</a>
                                </li>
                            </c:if>--%>
                            <c:if test="${fn:length(categoryList) > 0}">
                                <li>
                                    <a data-toggle="tab" href="#faq-tab-s" id="addQuestion"> Add Announcement </a>
                                </li>
                            </c:if>
                        </ul>
                    </li><!-- /.dropdown -->
                </c:if>
                <%-- /settings --%>
            </ul>

            <%-- here we query the questions for each category --%>
            <div class="tab-content no-border padding-24">
                <c:forEach var="category" items="${categoryList}" varStatus="loop">
                    <div id="faq-tab-${category.id}" class="tab-pane fade in <c:if test="${empty activeCat && loop.index == 0}">active</c:if><c:if test="${category.id == activeCat}">active</c:if>">
                            <h4 class="blue">
                                <i class="ace-icon fa fa-check bigger-110"></i>
                            ${category.categoryName}
                            <%--<c:if test="${allowEdit == true}">
                                <a href="#" class="btn-sm btn-app btn-primary editCategory" rel="${category.id}">
                                    <i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                    Edit
                                </a>
                            </c:if>--%>
                        </h4>

                        <div class="space-8"></div>

                        <c:choose>
                            <c:when test="${empty category.faqQuestions}">
                                <div class="center"><h5>There are currently no questions for this category.</h5></div>
                            </c:when>
                            <c:otherwise>
                                <div id="faq-list-${category.id}" class="panel-group accordion-style1 accordion-style2">
                                    <c:forEach var="question" items="${category.faqQuestions}">

                                        <%-- question --%>
                                        <div class="panel panel-default">
                                            <div class="panel-heading clearfix">
                                                <a href="#faq-${category.id}-${question.id}" data-parent="#faq-list-${category.id}" data-toggle="collapse" class="accordion-toggle collapsed">
                                                    <i class="ace-icon fa smaller-80 
                                                       <c:if test='${question.id != activeQuestion}'>fa-chevron-right</c:if>
                                                       <c:if test='${question.id == activeQuestion}'>fa-chevron-down</c:if>" 
                                                           data-icon-hide="ace-icon fa fa-chevron-down align-top " 
                                                           data-icon-show="ace-icon fa fa-chevron-right">
                                                       </i>

                                                    ${question.question}
                                                </a>
                                            </div>

                                            <div class="panel-collapse collapse <c:if test='${question.id == activeQuestion}'>in </c:if>" id="faq-${category.id}-${question.id}">
                                                    <div class="panel-body">
                                                    ${question.answer}
                                                    <c:if test="${not empty question.faqQuestionDocuments}">
                                                        <div><hr></div>
                                                        <div>
                                                            <h5>Documents</h5>
                                                            <c:forEach var="document" items="${question.faqQuestionDocuments}">
                                                                <div class="clearfix">
                                                                    <i class="fa fa-file bigger-110 orange"></i> <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.documentTitle}&foldername=faqUploadedFiles"/>" title="${document.documentTitle}">${document.documentTitle}</a>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${allowEdit == true}">
                                                        <div class="space-8"></div>
                                                        <div>
                                                            <a href="#" class="btn-sm btn-app btn-primary editQuestion" rel="${question.id}">
                                                                <i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
                                                                Edit
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>  
                                        </div>
                                    </c:forEach>      
                                </div>
                            </c:otherwise>
                        </c:choose>    

                    </div>
                </c:forEach>
            </div>
        </div>
        <%-- need to remove user role --%>
        <sec:authorize access="hasAnyRole('ROLE_PROGRAMADMIN', 'ROLE_SYSTEMADMIN')">
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
<%-- 
    Document   : qDocumentInc
    Created on : Jun 14, 2015, 4:33:33 PM
    Author     : Grace
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div id="documentListDiv">               
    <c:if test="${fn:length(documentList) > 0}">
        <div class="row">
            <hr/>
            <label for="document1">Documents</label>
        </div>
    </c:if>
    <%-- documents for questions --%>

    <c:forEach  var="document" items="${documentList}">
        <div class="row" style="margin-top:20px;">
            <div class="col-sm-4">
                <a href="#" class="btn-xs btn-app btn-danger deleteDocument" rel="${document.id}">
                    <i class="ace-icon fa fa-trash-o smaller-90"></i>
                    Delete
                </a>
                <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
                </sec:authorize>                          
            </div>   
            <div class="col-lg-4">
                <a href="<c:url value="/FileDownload/downloadFile.do?filename=${document.documentTitle}&foldername=faqUploadedFiles"/>">
                    ${document.documentTitle}
                </a>
            </div>

        </div>
    </c:forEach>
</div>

<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        <c:if test="${not empty errorCodes}" >
            <div class="alert alert-danger">
                <strong>The last file uploaded failed our validation!</strong> 
                <br />
                <c:forEach items="${errorCodes}" var="code">
                    <c:choose>
                        <c:when test="${code == 1}">- The file uploaded was empty.</c:when>
                        <c:when test="${code == 2}">- The file uploaded exceeded the max size 10MB.</c:when>
                        <c:when test="${code == 3}">- The file uploaded was not the correct file type.</c:when>
                        <c:when test="${code == 4}">- The file uploaded did not the correct field columns.</c:when>
                    </c:choose>
                    <br />
                </c:forEach>
            </div>
        </c:if>
        <c:choose>
            <c:when test="${not empty param.msg}" >
                <div class="alert alert-success">
                    <strong>Success!</strong> 
                    <c:choose>
                        <c:when test="${param.msg == 'updated'}">The client has been successfully updated!</c:when>
                        <c:when test="${param.msg == 'created'}">The client has been successfully added!</c:when>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
        

        <section class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Import Templates</h3>
            </div>
            <div class="panel-body">
                <div class="alert alert-info">
                    <p>
                        <strong>Instructions:</strong><br />
                        1.) Click a link below to download your data import template as a CSV (comma delimited) file. Save it locally to your computer and then open it to begin filling it with the data you wish to import.
                        <br /><br />
                        2.) In each column of the Data Import Template file that you downloaded, place the data for each record that you wish to import. Once all your data has been added, save the file.
                        <ul>
                            <li>Be sure not to change the Variables/Field Names in the file or an error may occur.</li>
                            <li>Also, for all of the 'dropdown' or 'radio' fields in the project, you must make sure that the numerical value (rather than the text value) is entered in those cells, or else it cannot be processed.</li>
                            <li>Any empty rows or columns in the file can be safely deleted before importing the file. Doing this reduces the upload processing time, especially for large projects.</li>
                        </ul>
                        <br />
                        3.) Click the 'Browse' or 'Choose File' button below to select the file on your computer, and upload it by clicking the 'Upload File' button.
                        <br /><br />
                        4.) Once your file has been uploaded, the data will NOT be immediately imported but will be displayed and checked for errors to ensure that all the data is in correct format before it is finally imported into the project. 
                    </p>
                </div>
                <div class="form-container scrollable">
                    <table class="table table-striped table-hover table-default" <c:if test="${not empty clients}">id="dataTable"</c:if>>
                        <thead>
                            <tr>
                                <th scope="col">Import Template</th>
                                <th scope="col" class="center-text">Date Created</th>
                                <th scope="col" class="center-text"></th>
                            </tr>
                        </thead>
                       <tbody>
                            <c:choose>
                                <c:when test="${not empty importTypes}">
                                    <c:forEach var="importType" items="${importTypes}">
                                        <tr>
                                            <td scope="row">
                                                ${importType.name}
                                            </td>
                                            <td class="center-text"><fmt:formatDate value="${importType.dateCreated}" type="date" pattern="M/dd/yyyy" /></td>
                                            <td class="actions-col">
                                                <a href="<c:url value="/FileDownload/downloadFile.do?filename=${importType.templateFileName}&foldername=import files&programId=${importType.programId}"/>"  class="media-modal" title="Download this import template">
                                                    <span class="glyphicon glyphicon-download"></span>
                                                    Download Data Import Template
                                                </a>
                                                <a href="#uploadFile" data-toggle="modal" class="btn btn-link uploadImportFile" rel="${importType.id}" title="Upload Import File">
                                                    <span class="glyphicon glyphicon-upload"></span>
                                                    Upload File
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="3" class="center-text">There are currently no import templates set up.</td></tr>
                                </c:otherwise>
                            </c:choose>
                       </tbody>
                </table>
                </div>
            </div>
        </section>
    </div>
</div>
<div class="modal fade" id="uploadFile" role="dialog" tabindex="-1" aria-labeledby="" aria-hidden="true" aria-describedby=""></div>




<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="modal-dialog">
    <div class="modal-content"  style="width:800px">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Modified By</h3>
        </div>
        <div class="modal-body" >
            <table class="table table-striped table-default">
                <thead>
                    <tr>
                        <th scope="col" style="width:20%">Modified By</th>
                        <th scope="col" style="width:20%">Modified Date / Time</th>
                        <th scope="col" style="width:30%">Old Value</th>
                        <th scope="col" style="width:30%">New Value</th>
                    </tr>
                </thead>
               <tbody>
                    <c:forEach var="fieldmod" items="${fieldModifications}">
                        <tr>
                            <td>
                               ${fieldmod.modifiedBy}
                            </td>
                            <td>
                                <fmt:formatDate value="${fieldmod.dateCreated}" type="Date" pattern="M/dd/yyyy" /> @
                                <fmt:formatDate value="${fieldmod.dateCreated}" type="Time" pattern="h:mm a" />
                            </td>
                            <td>
                               ${fieldmod.oldFieldValue}
                            </td>
                            <td>
                               ${fieldmod.newFieldValue}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- 
    Document   : newEventTypeModal
    Created on : Jun 2, 2015, 5:24:12 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Event Type Manager Modal -->
<div class="modal fade" id="eventTypeManagerModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>--%>
                <button type="button" id="addNewEventTypeButton" class="btn btn-default pull-right">
                    <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                </button>
                <h4 class="modal-title" id="myModalLabel">Event Types</h4>
            </div>
            <div class="modal-body">
                <table cellspacing="0" cellpadding="0" border="0" width="100%" id="eventTypesTable" class="cell-border stripe">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Event Type Category</th>
                            <th>Admin Only</th>
                            <th></th>
                        </tr>
                    </thead>
                </table>
                
                <br />
                
                <form id="newEventTypeForm" style="display:none;">
                    <input type="hidden" id="eventTypeId" name="eventTypeId" value="0" />
                    <h4 id="eventTypeHeading"></h4>
                    <hr />
                    <div class="form-group">
                        <label for="eventTypeColor">Hex Color</label>
                        <div class="form-inline">
                        <input type="text" class="form-control input-sm col-sm-1 eventTypeColorField" id="eventTypeColorField" name="eventTypeColorField" placeholder="eg #FFFFFF" />
                        &nbsp;
                        <select class="form-control eventTypeColor" id="eventTypeColor" name="eventTypeColor">
                            <c:forEach var="color" items="${colors}">
                                <option value="${color.typeColor}">${color.typeColor}</option>
                            </c:forEach>
                        </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="eventCategory">Event Type Category</label>
                        <input type="text" class="form-control" id="eventType" name="eventType" placeholder="Category Name" />
                    </div>
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" id="adminOnly" name="adminOnly" value="1" /> Admin Only Event
                        </label>
                    </div>
                    <hr />
                    <button type="submit" class="btn btn-primary" id="newEventSaveButton" name="newEventSaveButton">Save</button>
                </form>
            </div>
        </div>
    </div>
</div>

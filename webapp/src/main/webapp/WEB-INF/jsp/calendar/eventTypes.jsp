<%-- 
    Document   : newEventTypeModal
    Created on : Jun 2, 2015, 5:24:12 PM
    Author     : Jim
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<div class="row" style="height:250px; overflow: auto">
    <div class="col-sm-12">
        <table cellspacing="0" cellpadding="0" border="0" width="100%" id="eventTypesTable" class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
            <thead>
                <tr>
                    <th></th>
                    <th>Event Type</th>
                    <th>Admin Only</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty eventTypes}">
                        <c:forEach var="eventType" items="${eventTypes}">
                            <tr>
                                <td class="center">
                                    <span class="btn-colorpicker center white" style="background-color:${eventType.eventTypeColor}; height:15px; width: 15px;"></span>
                                </td>
                                <td>
                                    ${eventType.eventType}
                                </td>
                                <td class="center">
                                    <c:if test="${eventType.adminOnly == true}">
                                        <div class="hidden-sm hidden-xs btn-group">
                                            <button class="btn btn-xs btn-success">
                                                <i class="ace-icon fa fa-check bigger-120"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                </td>
                                <td class="center">
                                    <div class="hidden-sm hidden-xs btn-group">
                                        <button class="btn btn-xs btn-info">
                                            <i class="ace-icon fa fa-pencil bigger-120"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td class="center">
                                There are no event types set up.
                            </td>
                        </tr>
                    </c:otherwise>        
                </c:choose> 
            </tbody>    
        </table>
    </div>
</div>
<div id="newEventTypeForm" class="row">
    <div class="col-sm-12">
        <form>
            <input type="hidden" id="eventTypeId" name="eventTypeId" value="0" />
            <h4 id="eventTypeHeading"></h4>
            <hr />
            <div class="clearfix">
                <label for="eventTypeColorField">Color Picker</label>
            </div>
            <div class="form-group">
                <div class="control-group">
                    <div class="input-group" data-color="#F5F5F5" data-color-format="hex" id="eventTypeColorField">
                        <input type="text" id="eventTypeColorFieldInput" class="form-control" value="" readonly="true" >
                        <span class="input-group-addon center white" id="eventTypeColorFieldAddon" style="background-color:#e23b3b; height:15px; width: 15px;"></span>
                    </div>
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

<!-- Event Type Manager Modal
<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header no-padding grey">
                <div class="table-header widget-header">
                    <span class="widget-toolbar">
                        <a href="#" id="addNewEventTypeButton" data-action="settings">
                            <i class="ace-icon green fa fa-plus"></i>
                        </a>
                        <a href="#" data-dismiss="modal" aria-hidden="true">
                            <i class="ace-icon red fa fa-times"></i>
                        </a>
                    </span>
                    Event Types
                </div>
            </div>
            <div class="modal-body">
                

                
            </div>
        </div>
    </div>
</div>
-->
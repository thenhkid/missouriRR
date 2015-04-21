
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3 class="panel-title">Enter Client Number ${success}</h3>
        </div>
        <div class="modal-body">
            
            <c:if test="${not empty msg}" >
                <div class="alert alert-danger">
                    ${msg}
                </div>
            </c:if>
            
            <div class="form-group ${status.error ? 'has-error' : '' }">
                <input type="text" id="clientNumber" class="form-control" type="text" maxLength="9" />
            </div>
            <div class="form-group">
                <input type="button" id="saveNewClientNumber" role="button" class="btn btn-primary" value="Enter"/>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function() {
        $("input:text,form").attr("autocomplete", "off");
       
    });

</script>
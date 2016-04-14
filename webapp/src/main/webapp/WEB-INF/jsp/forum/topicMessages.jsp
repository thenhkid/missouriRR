<%-- 
    Document   : forum
    Created on : Jun 1, 2015, 10:42:48 AM
    Author     : chadmccue
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="col-xs-12 topicMessageContainer" rel="${topicId}">
    <div class="row">
        <div class="clearfix">
            <div class="pull-left" style="display:none" id="loadingDiv">
                <h4 class=" smaller lighter grey">
                    <i class="ace-icon fa fa-spinner fa-spin orange bigger-150"></i>
                    Loading Messages
                </h4>
            </div>
            <div class="pull-right">
                <c:if test="${allowCreate == true}">
                    <button class="btn btn-success btn-xs" type="button" rel="${topicId}" id="newPost">
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        New Post
                    </button>
                </c:if>
            </div>
        </div>
    </div>
    <div class="hr dotted"></div>
    <c:if test="${not empty error}" >
        <div class="alert alert-danger" role="alert">
            The selected file was not found.
        </div>
    </c:if>
</div>

<div class="row">

    <div id="timeline-1">
        <div class="row">
            <div class="col-xs-12 col-sm-10 col-sm-offset-1" id="messagesDiv"></div>
        </div>
    </div>

    <!-- PAGE CONTENT ENDS -->
</div><!-- /.col -->
</div><!-- /.row -->
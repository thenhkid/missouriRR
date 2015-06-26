<%-- 
    Document   : forum
    Created on : Jun 1, 2015, 10:42:48 AM
    Author     : chadmccue
--%>

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
                <button class="btn btn-success btn-xs" type="button" rel="${topicId}" id="newPost">
                    <i class="ace-icon fa fa-plus-square bigger-110"></i>
                    New Post
                </button>
            </div>
        </div>
    </div>
    <div class="hr dotted"></div>
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
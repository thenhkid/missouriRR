

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<aside class="secondary"  style="margin-left:10px;">
    <div class="container">
        <div class="row">
            <div class="col-sm-3 col-md-3" style="width:21%;">
                <div class="panel-group" id="accordion">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a  data-parent="#accordion" href="#collapseOne"><span class="glyphicon glyphicon-folder-close" style="margin-right:10px;">
                                </span><strong>Surveys</strong></a>
                            </h4>
                        </div>
                        <div id="collapseOne" class="panel-collapse collapse in">
                            <div class="panel-body" style="padding:0px;">
                                <table class="table" style="margin-bottom: 0px;  margin-top:0px;">
                                    <c:forEach var="survey" items="${surveys}">
                                        <tr>
                                            <td style="padding-left: 15px" ${selSurvey == survey.id ? 'class="active survey"' : 'class="survey"'}>
                                                <a href="/surveys?i=${survey.encryptedId}&v=${survey.encryptedSecret}" class="loadActivityLog" rel="${survey.id}" title="${survey.title}">${survey.title}
                                                <span class="glyphicon glyphicon-forward text-primary pull-right"></span></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</aside>

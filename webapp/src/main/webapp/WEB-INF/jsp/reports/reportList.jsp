<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div class="col-sm-12">
    <%--
    <div class="row">
        <div class="clearfix">
            <div class="dropdown pull-left no-margin">
                <button class="btn btn-default btn-xs dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
                    Preferences
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="preferences">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" id="documentNotificationManagerModel">Report Notification Preferences</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="hr dotted"></div>
    --%>
    <div class="row">
        <div class="clearfix">
            <%--<c:if test="${allowCreate == true}">--%>
            <c:if test="${1 == 1}">    
                <div class="pull-right no-margin col-md-6">
                    <a href="/reports/request">
                    <button class="btn btn-success btn-xs pull-right" type="button" id="newDocument" >
                        <i class="ace-icon fa fa-plus-square bigger-110"></i>
                        Request a new report
                    </button>
                    </a>

                </div>
            </c:if>
        </div>
        <div class="hr dotted"></div>
    </div>
    <div class="col-sm-12">

        <div class="row">
            <div class="table-header">
                Reports Requested
            </div>

            <table <c:if test="${not empty documents}">id="dynamic-table"</c:if> class="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th scope="col" class="center col-md-1"></th>
                            <th scope="col" class="col-md-5">Report Details</th>
                            <th scope="col" class="center col-md-2"><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i> Date Submitted</th>
                            <th scope="col" class="col-md-2">Requested By</th>
                            <th scope="col" class="center col-md-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                    
                        
                            
                                <tr>
                                    <td class="center" style="vertical-align: middle; ">
                                        
                                            
                                                <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                    <div class="infobox-icon">
                                                        <i class="ace-icon fa fa-file-pdf-o"></i>
                                                    </div>
                                                </div>
                                            
                                            
                                            
                                            
                                            
                                        
                                    </td>
                                    <td>
                                        <strong>Report 123</strong>
                                        
                                        
                                            <br />
                                            Campbell Elementary
                                            <br/>
                                            Meetings
                                        
                                    </td>
                                    <td class="center">
                                        8/21/2015 1:56 AM
                                    </td>
                                    <td>
                                        Grace Chan
                                    </td>
                                    <td  class="center">
                                        <div class="hidden-sm hidden-xs btn-group">
                                            
                                                <a class="btn btn-xs btn-success" href="/FileDownload/downloadFile.do?filename=sampleMeeting.pdf&foldername=reports" title="Test PDF">
                                                <i class="ace-icon fa fa-download bigger-120"></i>
                                                </a>
                                                <button class="btn btn-xs btn-danger deleteDocument" rel="1"><i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            
                                        </div>
                                    </td>
                                </tr>
                            
                                <tr>
                                    <td class="center" style="vertical-align: middle; ">
                                        
                                            
                                                <div class="infobox infobox-blue" style="width:50px; height:45px; text-align: center; padding:0px; background-color: transparent; border: none;">
                                                    <div class="infobox-icon">
                                                        Not Ready
                                                    </div>
                                                </div>
                                            
                                            
                                            
                                            
                                            
                                        
                                    </td>
                                    <td>
                                        <strong>Houston Elementary</strong>
                                        
                                        
                                            <br />
                                            
                                        
                                    </td>
                                    <td class="center">
                                        09/02/2015 1:57 AM
                                    </td>
                                    <td>
                                        Grace Chan
                                    </td>
                                    <td  class="center">
                                        <div class="hidden-sm hidden-xs btn-group">
                                            
                                                
                                            
                                                <button class="btn btn-xs btn-danger deleteDocument" rel="2"><i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            
                                        </div>
                                    </td>
                                </tr>
                            
                        
                        
                    
                </tbody>
            </table>
                </tbody>
            </table>
        </div>

    </div><!-- /.col -->
</div>



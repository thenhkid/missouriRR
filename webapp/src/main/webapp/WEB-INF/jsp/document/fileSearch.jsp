<%-- 
    Document   : list
    Created on : Mar 5, 2015, 12:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<form>
    <input type="hidden" id="savedSearchString" value="${savedSearchString}" />
    <input type="hidden" id="savedadminOnly" value="${savedadminOnly}" />
    <input type="hidden" id="savedstartSearchDate" value="${savedstartSearchDate}" />
    <input type="hidden" id="savedendSearchDate" value="${savedendSearchDate}" />
</form>

<div class="col-sm-12">
    <div class="row">
        <div class="col-xs-12">
            <div class="widget-box">
                <div class="widget-header widget-header-small">
                    <h5 class="widget-title lighter">Document Search</h5>
                </div>
                <div class="widget-body">
                    <div class="widget-main">
                        <form class="form-search">
                             <div class="row">
                                <div class="col-xs-12">
                                    <c:choose>
                                        <c:when test="${sessionScope.userDetails.roleId == 2 || sessionScope.userDetails.roleId == 4}">
                                            <div class="col-sm-6">
                                                <div class="row">
                                                    <h6>Admin Only Documents:</h6>
                                                </div>
                                                <div class="row">
                                                    <div class="input-group">
                                                        <div>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="adminOnly"  value="1"/> Yes
                                                            </label>
                                                            <label class="radio-inline">
                                                                <input type="radio" name="adminOnly" value="0" checked/> No
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                       </c:when>
                                       <c:otherwise><input type="radio" name="adminOnly" value="0" checked style="display:none"/></c:otherwise>
                                    </c:choose>
                                    <div class="col-sm-6">
                                        <div class="row">
                                            <h6>Date Uploaded:</h6>
                                        </div>
                                        <div class="row">
                                            <div class="input-daterange input-group">
                                                <input type="text" class="input-sm form-control" id="startSearchDate" name="start" placeholder="Start Date" />
                                                <span class="input-group-addon"><i class="fa fa-exchange"></i></span>
                                                <input type="text" class="input-sm form-control" id="endSearchDate" name="end" placeholder="End Date" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                             </div>
                            <div class="space-12"></div>
                            <div class="row">
                                <div class="col-xs-12">
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <h6>(Search on: Document title, description, folder/subfolder, uploaded/modified by)</h6>
                                        </div>
                                        <div class="row">
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <i class="ace-icon fa fa-check"></i>
                                                </span>

                                                <input type="text" id="documentSearchValue" class="form-control search-query" placeholder="Enter your search term" />
                                                <span class="input-group-btn">
                                                    <button type="button" id="documentSearchButton" class="btn btn-purple btn-sm">
                                                        <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                                        Search
                                                    </button>
                                                </span>
                                                <span class="input-group-btn" style="padding-left:10px; display:none" id="searchingDocuments">
                                                    <span class="label label-lg label-purple  middle">
                                                       <i class="ace-icon fa fa-spinner fa-spin white bigger-120"></i>
                                                        Searching
                                                    </span>
                                                </span>
                                                <span class="input-group-btn" style="padding-left:10px; display:none;" id="reqSearchTerm">
                                                    <span class="label label-danger label-white middle">
                                                        <i class="ace-icon fa fa-exclamation-triangle bigger-120"></i>
                                                        No search term entered
                                                    </span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div> 
        </div>
    </div>
    <div class="space-6"></div>
    <div class="space-6"></div>
    <c:if test="${not empty error}" >
        <div class="alert alert-danger" role="alert">
            The selected file was not found.
        </div>
    </c:if>
    <div id="documentSearchResults"></div>
</div>



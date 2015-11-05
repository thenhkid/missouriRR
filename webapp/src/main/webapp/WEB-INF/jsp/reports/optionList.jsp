<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    
    
<div class="row" div="entity2Div">
                <div class="col-sm-12">
                    <div class="widget-box">
                        <div class="widget-header">
                            <h4 class="widget-title">Please select district(s) </h4>

                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main">
                                <div>
                                    <select multiple="" name="entityIds" class="chosen-select form-control" id="schoolSelect" data-placeholder="Select Schools / ECC...">
                                       <c:forEach items="${entityList}" var="entity">
                                                    <option value="${entity.id}">${entity.name}</option>
                                            </c:forEach>        
                                    </select>
                                    <div id="errorMsg_schools" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>         
                                </div>
                            </div>   
                        </div>
                    </div>
                </div><!-- /.span -->
            </div><!-- /.row -->
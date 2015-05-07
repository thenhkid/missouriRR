<%-- 
    Document   : list
    Created on : Nov 20, 2014, 2:02:52 PM
    Author     : chadmccue
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>


<div class="main clearfix" role="main">
    <div class="col-md-12">
        <ul class="breadcrumb" style="background-color: #ffffff;">
            <li><a href="javascript:void('0');" id="countyName">Districts</a> <span class="divider"></span></li>
            <li class="active">Districts</li>
        </ul>
        <section class="panel panel-default">
            <div class="panel-body">
                <div class="form-container scrollable" id="districtList"></div>
            </div>
        </section>
    </div>
</div>


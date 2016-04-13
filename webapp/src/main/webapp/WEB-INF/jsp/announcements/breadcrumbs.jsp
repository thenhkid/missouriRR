<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<ul class="breadcrumb">
    <li>
        <i class="ace-icon fa fa-home home-icon"></i>
        <a href="/home">Home</a>
    </li>
    <c:choose>
        <c:when test="${param['page'] == 'list'}">
            
            <li class="active">
                Announcements
            </li>
        </c:when>
        <c:when test="${param['page'] == 'manage'}">
            <li>
                <a href="/announcements">Announcements</a>
            </li>
            <li class="active">
                Manage Announcements
            </li>
        </c:when>  
        <c:when test="${param['page'] == 'create'}">
            <li>
                <a href="/announcements">Announcements</a>
            </li>
            <li>
                <a href="/announcements/manage">Manage Announcements</a>
            </li>
            <li class="active">
                New Announcement
            </li>
        </c:when>           
        <c:when test="${param['page'] == 'edit'}">
            <li>
                <a href="/announcements">Announcements</a>
            </li>
            <li>
                <a href="/announcements/manage">Manage Announcements</a>
            </li>
            <li class="active">
                Edit Announcement
            </li>
        </c:when>       
    </c:choose>
</ul>
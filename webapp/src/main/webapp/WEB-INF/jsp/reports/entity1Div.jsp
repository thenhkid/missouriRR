<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script src="/dspResources/js/reports/entity1Div.js"></script>

<div class="col-sm-12" id="entity1DivId">
	<div class="widget-box">
		<div class="widget-header">
			<h4 class="widget-title">${orgHierarchyList[0].name}</h4>
			<div class="widget-toolbar">
			<a href="#" data-action="collapse">
			<i class="ace-icon fa fa-chevron-up inactive"></i>
			</a>
			</div>
		</div>
		<div class="widget-body">
			<div class="widget-main">
				<div id="selectEntity1Div">
					<select name="selectedEntities" class="multiselect form-control" id="entity1Ids" multiple="">
					<c:forEach items="${entity1List}" var="entity">
					<option value="${entity.id}" <c:if test="${fn:length(entity1List) == 1}"> selected</c:if>>${entity.name}</option>
					</c:forEach>
					</select>
					<div id="errorMsg_entity1" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
				</div>
				<div>
					<button class="btn btn-success btn-next showEntity2Div1Button" id="showEntity2Div1Button" data-last="Show ${orgHierarchyList[1].name}" rel="${orgHierarchyList[0].name}">
					Show ${orgHierarchyList[1].name}
					</button>
						<button class="btn btn-success btn-next changeEntity1Button" id="changeEntity1Button" data-last="Change ${orgHierarchyList[0].name}" style="display: none;">
					Change ${orgHierarchyList[0].name}
					</button>
				</div>
			</div>
		</div>
	</div>
</div><!-- /.span -->
